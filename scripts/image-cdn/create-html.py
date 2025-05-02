import markdown
from pathlib import Path
import re

# Paths to input and output files
input_md_path = "README.md"  # Update this path to your Markdown file
# Update this path for the HTML output
output_html_path = "src/README-logos.html"

# HTML template to wrap the converted content
html_template = """<!DOCTYPE html>
<html>
<head>
		<meta name="robots" content="noindex, nofollow">
		<meta charset="utf-8" />
		<title>MON Branding Images CDN</title>
		<style>
				body {{
						font-family: sans-serif;
						background-color: #fff;
						color: #000;
						margin: 0;
						padding: 0;
						font-size: 16px;
						line-height: 1.6;
				}}
				h2, h3, h4, h5, h6 {{
						margin-top: 1.5em;
				}}
				ul {{
						padding-left: 1em;
				}}
				.toc > ul {{
					column-count: 2;
					column-gap: 1em;

					> li {{
					break-inside: avoid;
					font-weight: bold;
					width: 90%;
					margin: 0 0 1em;

						li {{
							font-weight: normal; /* Ensure sub-items are normal weight */
							font-size: 14px;
						}}
					}}
				}}
				p img {{
					max-width:200px;
					height: auto;
				}}
				a {{
						text-decoration: none;
						color: #007BFF;
				}}
				a:hover {{
						text-decoration: underline;
				}}
				.content {{
						padding-top: 1rem;
						margin-top: 1rem;
						border-top: 1px solid #808080;
				}}
				/* Skip link styles */
				.skip-link {{
						position: absolute;
						top: -40px;
						left: 10px;
						background: #007BFF;
						color: white;
						padding: 8px 16px;
						text-decoration: none;
						border-radius: 4px;
						z-index: 1000;
				}}
				.skip-link:focus, .skip-link:hover {{
						top: 10px;
				}}
		</style>
</head>
<body>
	<!-- Skip link -->
	<a href="#main" class="skip-link">Skip to main content</a>

	<div style="max-width: 800px; margin: 20px auto; padding: 1em;">
		<h1>{title}</h1>

		<div class="toc">
			{toc}
		</div>

		<div class="content" id="main">
			{content}
		</div>
	</div>
</body>
</html>
"""


def generate_toc_and_ids(md_content):
    """Generate a Table of Contents (TOC) with ## and ### headings, excluding the # heading."""
    toc = []
    updated_md_content = []
    id_counts = {}  # Track duplicate IDs
    current_top_level = None
    main_title = None

    for line in md_content.splitlines():
        # Match Markdown headers (e.g., #, ##, ###)
        header_match = re.match(r"^(#{1,3})\s+(.+)", line)
        if header_match:
            level = len(header_match.group(1))  # Number of # symbols
            title = header_match.group(2).strip()
            clean_title = re.sub(
                r"[^\w\s\-]", "", title).replace(" ", "-").lower()

            # Handle the # level heading (main title)
            if level == 1 and not main_title:
                main_title = title  # Extract the main title
                continue  # Skip adding it to the TOC or content

            # Ensure unique IDs
            if clean_title in id_counts:
                id_counts[clean_title] += 1
                anchor = f"{clean_title}-{id_counts[clean_title]}"
            else:
                id_counts[clean_title] = 1
                anchor = clean_title

            # Build the TOC and updated content
            if level == 2:  # Top-level heading (##)
                if current_top_level is not None:
                    # Close the previous top-level item
                    toc.append("</ul></li>")
                toc.append(f'<li><a href="#{anchor}">{title}</a><ul>')
                current_top_level = anchor
                updated_md_content.append(
                    f'<h{level} id="{anchor}">{title}</h{level}>')
            # Nested heading (###)
            elif level == 3 and current_top_level is not None:
                toc.append(f'<li><a href="#{anchor}">{title}</a></li>')
                updated_md_content.append(
                    f'<h{level} id="{anchor}">{title}</h{level}>')
        else:
            # Add non-header lines to the updated Markdown content
            updated_md_content.append(line)

    # Close any remaining open tags
    if current_top_level is not None:
        toc.append("</ul></li>")

    # Wrap the TOC in a <ul>
    toc_html = f"<ul>{''.join(toc)}</ul>"

    return main_title, toc_html, "\n".join(updated_md_content)


def convert_md_to_html(input_path, output_path):
    """Convert Markdown to HTML."""
    try:
        # Check if the input file exists
        if not Path(input_path).exists():
            raise FileNotFoundError(f"Input file not found: {input_path}")

        # Read the Markdown file
        md_content = Path(input_path).read_text()

        # Generate the main title, TOC, and updated Markdown content
        main_title, toc_html, updated_md_content = generate_toc_and_ids(
            md_content)

        # Replace image paths from './src/folder' to 'folder'
        updated_md_content = updated_md_content.replace("src/", "")

        # Handle <div> with background styling for white images
        updated_md_content = re.sub(
            r'<div style="background:\s*black;">\s*!\[(.*?)\]\((.*?)\)\s*</div>',
            r'<div style="background: black; padding: 10px;"><img alt="\1" src="\2" style="display: block; margin: auto;" /></div>',
            updated_md_content,
        )

        # Convert the updated Markdown to HTML
        html_content = markdown.markdown(
            updated_md_content, extensions=["fenced_code"]
        )

        # Wrap the HTML content in the template
        full_html = html_template.format(
            content=html_content,
            toc=toc_html,
            title=main_title  # Insert the main title into the template
        )

        # Write the output to the HTML file
        Path(output_path).write_text(full_html)
        print(f"HTML file saved to {output_path}")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    convert_md_to_html(input_md_path, output_html_path)
