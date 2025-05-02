import subprocess
import re
from collections import defaultdict


def get_last_date_from_changelog(changelog_path):
    """Extract the last date from the CHANGELOG.md file."""
    with open(changelog_path, "r") as file:
        for line in file:
            match = re.search(r"## \[\d+\.\d+\] - (\d{4}-\d{2}-\d{2})", line)
            if match:
                return match.group(1)  # Return the last date found
    return None


def get_last_version_from_changelog(changelog_path):
    """Extract the last version from the CHANGELOG.md file."""
    with open(changelog_path, "r") as file:
        for line in file:
            match = re.search(r"## \[(\d+\.\d+)\]", line)
            if match:
                return match.group(1)  # Return the last version found
    return None


def get_git_log_since(last_date):
    """Get git log entries since the last date."""
    git_log_cmd = [
        "git",
        "log",
        f"--since={last_date}",
        "--pretty=format:%ad|%s",
        "--date=short",
    ]
    result = subprocess.run(git_log_cmd, capture_output=True, text=True, check=True)
    return result.stdout.strip().split("\n")


def get_most_recent_commit_date():
    """Get the date of the most recent commit."""
    git_log_cmd = ["git", "log", "-1", "--pretty=format:%ad", "--date=short"]
    result = subprocess.run(git_log_cmd, capture_output=True, text=True, check=True)
    return result.stdout.strip()


def group_commits_by_date(commits):
    """Group commits by their commit date."""
    grouped_commits = defaultdict(list)
    for commit in commits:
        date, message = commit.split("|", 1)
        grouped_commits[date].append(message.strip())
    return grouped_commits


def update_changelog(changelog_path, grouped_commits, new_version, release_date):
    """Update the CHANGELOG.md file with new commits."""
    with open(changelog_path, "r") as file:
        changelog_content = file.readlines()

    # Find the insertion point (after the header)
    insertion_index = 0
    for i, line in enumerate(changelog_content):
        if line.startswith("## ["):
            insertion_index = i
            break

    # Build the new changelog content
    new_entries = [f"## [{new_version}] - {release_date}\n"]
    for date, messages in grouped_commits.items():
        for message in messages:
            new_entries.append(f"- {message}\n")
    new_entries.append("\n")

    # Insert the new entries into the changelog
    updated_content = (
        changelog_content[:insertion_index]
        + new_entries
        + changelog_content[insertion_index:]
    )

    # Write the updated changelog back to the file
    with open(changelog_path, "w") as file:
        file.writelines(updated_content)


if __name__ == "__main__":
    changelog_path = "CHANGELOG.md"
    last_date = get_last_date_from_changelog(changelog_path)
    if not last_date:
        print("No valid date found in CHANGELOG.md. Exiting.")
        exit(1)

    last_version = get_last_version_from_changelog(changelog_path)
    if not last_version:
        print("No valid version found in CHANGELOG.md. Exiting.")
        exit(1)

    # Increment the version by 0.01
    major, minor = map(int, last_version.split("."))
    new_version = f"{major}.{minor + 1}"

    # Use the most recent commit's date as the release date
    release_date = get_most_recent_commit_date()

    print(f"Last date in CHANGELOG.md: {last_date}")
    print(f"New version: {new_version}, Release date: {release_date}")

    commits = get_git_log_since(last_date)
    if not commits or commits == [""]:
        print("No new commits found since the last date.")
        exit(0)

    grouped_commits = group_commits_by_date(commits)

    if not grouped_commits:
        print("No commits found.")
        exit(0)

    update_changelog(changelog_path, grouped_commits, new_version, release_date)
