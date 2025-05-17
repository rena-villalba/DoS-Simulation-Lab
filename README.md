## Suricata + Iptables DoS & Port Scan Detection Lab

## Objective
This lab aims to simulate a Denial-of-Service (DoS) attack and port scanning from one Linux virtual machine (VM) to another. The goal is to generate telemetry using two bash scripts: one that sends ICMP ping floods (DoS simulation) and another that performs multiple Nmap scans. The target VM, configured with Suricata (in IDS mode) and iptables, will detect and log both types of activity for analysis and potential integration with SIEM/SOAR tools.

## Requirements
- Two Linux-based VMs (Debian-based recommended)
- iptables (pre-installed on most Debian-based distros)
- suricata (previously installed and updated since we'll be using the Internal Network adapter)
- Bash script for DoS attack (ping flood)
- Bash script for port scanning (nmap usage)
- Static IP configuration for both VMs

## Project Tree
The following table shows where the configuration and script files from this repository should be placed in your virtual machines to ensure the lab functions correctly.
```
DoS-Simulation-Lab/
├── attacker/
│   ├── flood_script.sh
│   └── scanning_script.sh
├── target/
│   ├── firewall.sh
│   ├── suricata.yaml
│   └── rules/
│       ├── ping-flood.rules
│       └── port_scanning.rules
├── logs/
│   ├── fast.log
│   └── eve.json
└── README.md
```

## ## 🗃️ File Deployment Paths

| Repository File                  | VM Destination Path                                | Purpose                                |
|----------------------------------|-----------------------------------------------------|----------------------------------------|
| `target/firewall.sh`            | `/etc/iptables/rules/firewall.sh`                  | Custom iptables script                 |
| `target/suricata.yaml`          | `/etc/suricata/suricata.yaml`                      | Suricata configuration file            |
| `target/rules/ping-flood.rules`       | `/etc/suricata/rules/custom_rules/ping-flood.rules`      | Rules to detect ICMP ping flood         |
| `target/rules/port_scanning.rules`       | `/etc/suricata/rules/custom_rules/port_scanning.rules`      | Rule to detect Nmap scans              |
| `logs/fast.log`        | `/var/log/suricata/fast.log` (auto-generated)       | Suricata's real-time alert log         |
| `logs/eve.json`       | `/var/log/suricata/eve.json` (auto-generated)       | Detailed JSON event log from Suricata  |
| `attacker/flood_script.sh`        | `Desktop/`        | Ping Flood attack Script         |
| `attacker/scanning_script.sh`       | `Desktop/`        | Port Scanning Script  |


## Network Setup
| Role        | IP Address     | Description         |
| ----------- | -------------- | ------------------- |
| Target VM   | `10.0.8.80/24` | Suricata + iptables |
| Attacker VM | `10.0.8.56/24` | Bash attack scripts |

1. Assign static IPs on both VMs using the 10.0.8.0/24 subnet.
2. Use ip a to confirm the IP addresses are set correctly.
3. Test connectivity using ping from one VM to the other.

## Firewall Setup (Target VM)
Instead of setting each iptables rule manually, we'll create a script that contains all the firewall rules. This provides centralized control and easier modification in the future. The script will be stored inside the /etc/iptables/rules directory.

Note: The rules allow traffic to flow into the VM so Suricata can inspect packets. In a real scenario, stricter filtering should be applied.

## Suricata Setup (Target VM)
Create a dedicated folder inside the directory /etc/suricata/rules/custom_rules and the files ping-flood.rules and port_scanning.rules, then we edit the suricata.yaml file to add the path for both rules.

## Attacker VM - Scripts
We can create both scripts inside the Desktop directory, in this case it doesn't matter where we store them since this machine will only send the "attacks".

## Attack & Detection Phase
On the Target VM: Open two terminals

- Terminal 1 – Start Suricata

- Terminal 2 – Monitor Logs (You can also use tools like jq or grep on eve.json to parse detailed alerts.)

## On the Attacker VM:
Run the scripts one by one and observe the detections:

- Script 1 - sudo flood_script.sh 10.0.8.80

- Script 2 - sudo scanning_script 10.0.8.80

And we can see how the target VM captures or trigger the alerts in real-time for each case.

## Conclusion
This simple lab helps visualize how traffic inspection tools like Suricata work with basic firewall configurations to detect and log suspicious activity like DoS attacks or port scans. While minimalistic, the setup is ideal for extending into SIEM/EDR/SOAR integrations or deeper network forensics.

## Screenshots

*Img 1: Static Target IP*<br>
![1 targetvm_staticIP](https://github.com/user-attachments/assets/e64120f1-f65c-495a-a1ee-72592abfa018)

*Img 2: Terminal Verification*<br>
![2 targetvm_IP](https://github.com/user-attachments/assets/14bb550f-c5bc-4b5d-836b-2d4b3b4942e3)

*Img 3: Firewall Script*<br>
![3 target_firewall_sp](https://github.com/user-attachments/assets/5d13ee03-a71d-48bc-950e-753a81a223ce)

*Img 4: Iptables Rules*<br>
![4 iptables_sp](https://github.com/user-attachments/assets/540558df-7ddf-4bcb-bea0-5b4ee8bbbe95)

*Img 5: Iptables Executable*<br>
![5 iptables_execm](https://github.com/user-attachments/assets/ca32a43f-c939-4d25-8f68-5ac535125835)

*Img 6: Checking Firewall*<br>
![6 checking_iptables](https://github.com/user-attachments/assets/09ade55f-f073-42db-babf-cb01c8c09bad)

*Img 7: Saving the Firewall Configurations*<br>
![7 saving_iptablesconf](https://github.com/user-attachments/assets/4092b8ed-484a-40ca-822b-08c6cf3ccf55)

*Img 8 & 9: Updating Suricata and the Sources*<br>
![8 updating_suricata](https://github.com/user-attachments/assets/e54d863a-ec92-457a-8b7b-8f447120b74b)
![9 updating_sources](https://github.com/user-attachments/assets/34a1339b-e383-4b60-920a-489b4ea2fdaf)

*Img 10: Suricata Rules*<br>
![10 suricata_ls_rules](https://github.com/user-attachments/assets/5f8727c9-9496-4cea-8cc6-99588103a00b)

*Img 11 & 12: Ping Flood and Port Scanning Rules*<br>
![11 suricata_ping_rules](https://github.com/user-attachments/assets/2f63a61c-e239-4350-9a15-88e6e88859f1)
![12 suricata_port_rules](https://github.com/user-attachments/assets/5dd23d91-107b-4ae6-8d6b-1c03356106a4)

*Img 13 & 14: Adding the Rules to the suricata.yaml file and running Suricata on Test Mode*<br>
![13 adding_rules_to_suri_file](https://github.com/user-attachments/assets/677974e4-b191-47e4-9b3a-5fd61ee503e4)
![14 running_suricata_test_mode](https://github.com/user-attachments/assets/af5bddfb-b624-4420-b0d4-0dc9f6c5c7c2)

*Img 15: Static Attacker IP*<br>
![15 attackervm_staticIP](https://github.com/user-attachments/assets/fdca68d6-a0e1-4757-823b-252793126768)

*Img 16: Terminal Verification*<br>
![16 ip_cmd](https://github.com/user-attachments/assets/c852c14f-6acd-4074-93c5-a15b03833250)

*Img 17: Ping-Flood Script*<br>
![17 flood_script](https://github.com/user-attachments/assets/67f3cb0a-920f-4999-81a4-ae6e61102d05)

*Img 18: Port-Scanning Script*<br>
![18 nmap_sp](https://github.com/user-attachments/assets/d2e72318-82ba-4e53-9318-335331b5dfa6)

*Img 19: Making both Scripts executable*<br>
![18 1 both_executablescripts](https://github.com/user-attachments/assets/3af3dd15-19f5-4435-be9d-319b55c184d6)

*Img 20: Running Suricata and checking logs in real-time*<br>
![19 running_suricata_and_logs](https://github.com/user-attachments/assets/9ed79709-141b-42c8-ab5f-10ad425275d3)

*Img 21: Executing Port-Scanning Script*<br>
![20 attacker_port_scanning_sp](https://github.com/user-attachments/assets/c41511c3-92b2-418b-b263-746dde0d6cfa)

*Img 22: SYN Alert Triggered*<br>
![21 suricata_syn_alert](https://github.com/user-attachments/assets/dd739abb-1f7a-4734-b204-cb8c94dd2452)

*Img 23: FIN Alert Triggered*<br>
![22 suricata_fin_alert](https://github.com/user-attachments/assets/5ae36d70-c1ee-4fa3-97ac-b53bffe41a9d)

*Img 24: NULL Alert Triggered*<br>
![23 suricata_null_alert](https://github.com/user-attachments/assets/061896ff-11f7-4b88-85d7-7a50d8c7996d)

*Img 25: XMAS Alert Triggered*<br>
![24 suricata_xmas_alert](https://github.com/user-attachments/assets/c7c1519c-142f-4ea9-928f-ab5c5af3eb4a)

*Img 26: UDP Alert Triggered*<br>
![25 suricata_udp_alert](https://github.com/user-attachments/assets/4351cf43-779e-4fa6-80ed-1b837fcd676c)

*Img 27 & 28: Executing Ping-Flood Script*<br>
![26 attacker_flood_script](https://github.com/user-attachments/assets/81d0a433-7302-4ba0-9b10-1e4c276c4ca2)
![27 attacker_flood_script2](https://github.com/user-attachments/assets/a7ce8b0c-e1ab-4bd8-a56a-99acde784892)

*Img 29 & 30: ICMP and Ping-Flood Alert Triggered*<br>
![28 suricata_flood_alert1](https://github.com/user-attachments/assets/03a906d0-292a-4659-bc81-b85618afc4ee)
![29 suricata_flood_alert2](https://github.com/user-attachments/assets/d192d374-562f-4e79-b81f-60210906523b)

*Img 31: Checking Firewall Captured Traffic*<br>
![30 iptables_captured_traffic](https://github.com/user-attachments/assets/4299b965-bd4e-41c4-8cf1-f39b962011f4)

## 🛡️ Security & Ethics Statement

All activities demonstrated in this project are strictly confined to a virtual lab environment, under full control and with no connection to external networks or systems. This project simulates malicious behaviors such as DoS attacks and port scanning **solely for the purpose of learning how to detect, analyze, and respond to such events** using defensive tools like Suricata and iptables.

As an aspiring cybersecurity professional, I adhere to the principles of ethical hacking:

- I do **not** perform unauthorized testing or scanning on live networks or systems.
- I believe in the **responsible use of knowledge** to improve the security posture of systems, not exploit it.
- My goal is to **learn**, **share knowledge**, and **contribute** to a safer and more secure digital world.

If you plan to reuse or adapt this lab, ensure you do so within an isolated environment and **never** target systems without explicit permission.

#### ⚠️ Disclaimer

This project is intended **solely for educational and research purposes**. All simulations, including DoS and port scanning attacks, are conducted in a **controlled lab environment** using **virtual machines**.

**Do not** use these techniques on systems or networks you do not own or have explicit permission to test. Unauthorized scanning or disruption of services may be **illegal** and **against ethical guidelines**.

The author is **not responsible** for any misuse of the information provided in this repository.
