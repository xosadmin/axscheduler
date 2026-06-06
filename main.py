import os,sys,schedule
import time
from utils.yamlwork import read_yaml
from utils.commands import run_command

if not os.path.exists('config.yaml'):
    print('config.yaml not exist')
    sys.exit(128)

config = read_yaml('config.yaml')

def load_tasks():
    if not config["tasks"]:
        raise ValueError("No tasks defined in config.yaml")
    for task in config["tasks"]:
        name = task["name"]
        command = task["command"]
        schedule_config = task["schedule"]
        print(f"Loaded task: {name}")

        schedule_type = schedule_config["type"]

        if schedule_type == "interval":
            if "seconds" in schedule_config:
                schedule.every(schedule_config["seconds"]).seconds.do(run_command, name, command)

            elif "minutes" in schedule_config:
                at_time = schedule_config.get("at", ":00")
                schedule.every(schedule_config["minutes"]).minutes.at(at_time).do(run_command, name, command)

            elif "hours" in schedule_config:
                at_time = schedule_config.get("at", ":00")
                schedule.every(schedule_config["hours"]).hours.at(at_time).do(run_command, name, command)
            else:
                raise ValueError(f"Invalid interval task: {name}")

        elif schedule_type == "every_n_days":
            days = schedule_config["days"]
            at_time = schedule_config.get("at", "00:00:00")
            schedule.every(days).days.at(at_time).do(run_command, name, command)
        else:
            raise ValueError(f"Unknown schedule type: {schedule_type}")

def main():
    load_tasks()
    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == "__main__":
    main()