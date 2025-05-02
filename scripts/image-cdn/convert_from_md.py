import re
import json
import csv
import logging
import os
import sys  # Import the sys module
from urllib.parse import urlparse
import posixpath

# Configure logging to only log errors
logging.basicConfig(level=logging.ERROR)


def sanitize_tag(tag):
    """Remove ® and ™ symbols from a tag."""
    return tag.replace("®", "").replace("™", "").strip()


def infer_crop(brand, trait):
    """Infer the crop name based on the brand or trait."""
    crop_keywords = {
        "Cotton": ["Cotton", "Bollgard", "ThryvOn"],
        "Corn": ["Corn", "Trecepta", "VT Double PRO", "VT Triple PRO", "DroughtGard", "VT4PRO", "SmartStax"],
        "Soybeans": ["Soybeans", "Roundup Ready 2 Xtend", "XtendFlex", "Vyconic"],
        "Canola": ["Canola"],
        "Sugarbeets": ["Sugarbeets"],
        "Alfalfa": ["Alfalfa"]
    }

    for crop, keywords in crop_keywords.items():
        if any(keyword in (brand or "") for keyword in keywords) or any(keyword in (trait or "") for keyword in keywords):
            return crop
    return None  # Default to None if no crop can be inferred


def get_file_extension(url):
    """Extract the file extension from the URL."""
    parsed_url = urlparse(url)
    path = parsed_url.path
    _, ext = posixpath.splitext(path)
    return ext[1:].lower()  # Remove the leading dot and convert to lowercase


def transform_image_path(image_path):
    """Transforms the local image path to a CDN URL."""
    return image_path.replace("./src/", "https://monbranding.hlkagency.cloud/")


def parse_markdown(file_path):
    """Parse the Markdown file into structured data."""
    data = []
    image_data = []  # Separate list for image data
    current_brand = ""
    current_trait = ""

    try:
        with open(file_path, 'r') as file:
            for line in file:
                # Match image lines (e.g., ![Alt Text](URL))
                image_match = re.match(r"!\[(.*?)\]\((.+?)\)", line.strip())
                if image_match:
                    alt_text = image_match.group(1).strip()
                    image_path = image_match.group(2).strip()

                    # Transform the image path to CDN URL
                    image_url = transform_image_path(image_path)

                    # Determine the style based on filename
                    style = None
                    if "-white" in image_path.lower():
                        style = "white"
                    elif "-black" in image_path.lower():
                        style = "black"
                    elif "-reverse" in image_path.lower():
                        style = "reverse"

                    crop = infer_crop(current_brand, current_trait)
                    filetype = get_file_extension(image_url)

                    tags = [sanitize_tag(tag) for tag in [
                        current_brand, current_trait, filetype] if tag]

                    if crop:
                        tags.append(crop.lower())

                    if style:
                        tags.append(style)

                    brand = current_brand if current_brand else current_trait
                    trait = current_trait if current_trait else current_brand

                    sanitized_brand = sanitize_tag(current_brand)
                    sanitized_trait = sanitize_tag(trait)

                    image_data.append({
                        "url": image_url,
                        "alt": alt_text,
                        "brand": sanitized_brand,
                        "tags": tags,
                        "trait": sanitized_trait,
                        "filetype": filetype,
                        "crop": crop.lower() if crop else None,
                        "style": style
                    })

                # Match brand headers (e.g., ## Brand Name)
                brand_match = re.match(r"^##\s(.+?)$", line.strip())
                if brand_match:
                    current_brand = brand_match.group(1).strip()
                    current_trait = ""  # Reset the trait when a new brand is encountered
                    continue

                # Match trait headers (e.g., ### Trait Name)
                trait_match = re.match(r"^###\s(.+?)$", line.strip())
                if trait_match:
                    current_trait = trait_match.group(1).strip()
                    continue

                # Match links (e.g., * <https://example.com>)
                link_match = re.match(r"^\*\s+<(.+?)>$", line.strip())
                if link_match:
                    link = link_match.group(1).strip()
                    # Infer crop name
                    crop = infer_crop(current_brand, current_trait)
                    filetype = get_file_extension(
                        link)  # Extract file extension

                    # Sanitize tags to remove ® and ™
                    tags = [sanitize_tag(tag) for tag in [
                        current_brand, current_trait, crop, filetype] if tag]

                    # Handle special cases for brand and alt text
                    brand = current_brand
                    if not brand:
                        brand = current_trait  # Use trait for brand if brand is empty

                    # Ensure the trait is not empty; fallback to brand if missing
                    trait = current_trait if current_trait else current_brand

                    # Sanitize the brand and trait to remove ® and ™
                    # Remove ® and ™ from the brand
                    sanitized_brand = sanitize_tag(current_brand)
                    # Remove ® and ™ from the trait
                    sanitized_trait = sanitize_tag(trait)

                    # Use trait for alt text, fallback to brand if trait is missing
                    alt = current_trait if current_trait else current_brand

                    data.append({
                        "url": link,
                        "filetype": filetype,
                        "crop": crop.lower() if crop else None,
                        "alt": alt,  # Alt text retains ® or ™
                        "brand": sanitized_brand,  # Brand is sanitized
                        "trait": sanitized_trait,  # Trait is sanitized
                        "tags": tags
                    })
    except Exception as e:
        logging.error(f"Error while parsing the file: {e}")

    return data, image_data  # Return both lists


def filter_data(data, max_items_per_trait=3):
    """Filter data to reduce the number of items per trait."""
    trait_counts = {}
    filtered_data = []

    for item in data:
        trait = item['trait']
        if trait not in trait_counts:
            trait_counts[trait] = 0

        if trait_counts[trait] < max_items_per_trait:
            filtered_data.append(item)
            trait_counts[trait] += 1

    return filtered_data


def save_to_json(data, output_path):
    """Save structured data to a JSON file."""
    try:
        with open(output_path, 'w') as json_file:
            json.dump(data, json_file, indent=4, ensure_ascii=False)
        print(f"JSON file saved to {output_path}")
    except Exception as e:
        logging.error(f"Error while saving JSON: {e}")


def save_to_csv(data, output_path):
    """Save structured data to a CSV file."""
    try:
        with open(output_path, mode='w', newline='', encoding='utf-8') as csv_file:
            writer = csv.writer(csv_file)
            # Write CSV headers
            writer.writerow(["URL", "Alt", "Brand", "Trait", "Tags"])
            # Write data rows
            for entry in data:
                writer.writerow([
                    entry["url"],
                    entry["alt"],
                    entry["brand"],
                    entry["trait"],
                    ", ".join(entry["tags"])  # Join tags into a single string
                ])
        print(f"CSV file saved to {output_path}")
    except Exception as e:
        logging.error(f"Error while saving CSV: {e}")


if __name__ == "__main__":
    # Adjust paths for the new folder structure
    base_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(base_dir, "../README.md")
    output_json_file = os.path.join(base_dir, "../dist/cdn-images-list.json")
    output_filtered_json = os.path.join(
        base_dir, "../dist/cdn-images-list-filtered.json")
    output_csv_file = os.path.join(base_dir, "../dist/cdn-images-list.csv")

    # Check command-line arguments
    if len(sys.argv) > 1:
        mode = sys.argv[1]
    else:
        mode = "all"  # Default mode

    # Parse the markdown file
    parsed_data, image_data = parse_markdown(input_file)

    # Filter the data to reduce items per trait
    filtered_data = filter_data(parsed_data)

    if mode == "all":
        # Save all outputs
        save_to_json(filtered_data, output_json_file)
        save_to_json(image_data, output_filtered_json)
        save_to_csv(filtered_data, output_csv_file)
    elif mode == "filtered_json":
        # Save only the filtered JSON
        save_to_json(image_data, output_filtered_json)
    elif mode == "json":
        save_to_json(filtered_data, output_json_file)
    elif mode == "csv":
        save_to_csv(filtered_data, output_csv_file)
    else:
        print("Invalid mode specified.")
