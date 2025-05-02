import subprocess


def run_script(script_name, args=None):
    try:
        print(f"Running {script_name}...")
        if args:
            subprocess.run(
                ["python", f"scripts/{script_name}"] + args, check=True)
        else:
            subprocess.run(["python", f"scripts/{script_name}"], check=True)
        print(f"{script_name} completed successfully.\n")
    except subprocess.CalledProcessError as e:
        print(f"Error while running {script_name}: {e}\n")


if __name__ == "__main__":
    # List of scripts to run with their arguments
    scripts = [
        {"name": "create-html.py"},
        # Run convert_from_md.py with "all" argument
        {"name": "convert_from_md.py", "args": ["all"]}
    ]

    for script_data in scripts:
        run_script(script_data["name"], script_data.get("args"))
