import subprocess

def run_command(task_name, command):
    print(f"[{task_name}] Running: {command}")
    result = subprocess.run(command,shell=True,text=True,capture_output=True)
    if result.stdout:
        print(result.stdout.strip())
    if result.stderr:
        print(result.stderr.strip())