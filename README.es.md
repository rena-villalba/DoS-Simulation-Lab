# Laboratorio de Simulación de Ataques DoS

## Objetivo

El objetivo de este laboratorio es simular un ataque de Denegación de Servicio (DoS) y un escaneo de puertos entre dos máquinas virtuales Linux, con el fin de generar telemetría que pueda ser detectada por herramientas como Suricata (IDS) y reglas de iptables. Este laboratorio está diseñado para comprender cómo se comportan los ataques DoS y cómo pueden ser detectados y mitigados utilizando soluciones de seguridad de red.

## Requisitos

- 2 máquinas virtuales con Linux (se recomienda Ubuntu o Parrot OS)
- VirtualBox o cualquier otra plataforma de virtualización
- Suricata instalado en la máquina víctima
- Acceso root o privilegios de superusuario
- Conexión de red configurada entre las VMs (modo adaptador puente o red interna)

## Estructura del Proyecto

La siguiente tabla muestra dónde deben colocarse los archivos de configuración y scripts de este repositorio en tus máquinas virtuales para garantizar que el laboratorio funcione correctamente.
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
├── README.md
└── README.es.md

```

## Ruta de Archivos
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

## Configuración de Red
| Role        | IP Address     | Description         |
| ----------- | -------------- | ------------------- |
| Target VM   | `10.0.8.80/24` | Suricata + iptables |
| Attacker VM | `10.0.8.56/24` | Bash attack scripts |

1. Asigna direcciones IP estáticas en ambas máquinas virtuales utilizando la subred 10.0.8.0/24.  
2. Utiliza el comando `ip a` para confirmar que las direcciones IP se hayan configurado correctamente.  
3. Verifica la conectividad haciendo ping desde una VM hacia la otra.

## Configuración del Firewall

En lugar de establecer cada regla de iptables manualmente, crearemos un script que contenga todas las reglas del firewall. Esto permite un control centralizado y una modificación más sencilla en el futuro. El script se almacenará dentro del directorio `/etc/iptables/rules`.

> Nota: Las reglas permiten que el tráfico entre a la VM para que Suricata pueda inspeccionar los paquetes. En un entorno real, debería aplicarse un filtrado más estricto.

## Configuración de Suricata

Crea una carpeta dedicada dentro del directorio `/etc/suricata/rules/custom_rules` y coloca allí los archivos `ping-flood.rules` y `port_scanning.rules`.  
Luego, edita el archivo `suricata.yaml` para agregar la ruta de ambas reglas.

## Scripts en la VM Atacante

Podemos crear ambos scripts dentro del directorio Escritorio (`Desktop`).  
En este caso, no importa en qué ubicación se guarden, ya que esta máquina solo se encargará de enviar los "ataques".

## Fase de Ataque y Detección

### En la VM Objetivo:
Abre dos terminales:

- **Terminal 1** – Inicia Suricata  
- **Terminal 2** – Monitorea los logs  
  (También ae puede usar herramientas como `jq` o `grep` sobre `eve.json` para analizar alertas detalladas.)

### En la VM Atacante:
Ejecuta los scripts uno por uno y observa las detecciones:

- **Script 1** - `sudo flood_script.sh 10.0.8.80`  
- **Script 2** - `sudo scanning_script 10.0.8.80`

Podrás ver cómo la VM objetivo captura o genera alertas en tiempo real para cada caso.

---

## Conclusión

Este laboratorio simple ayuda a visualizar cómo las herramientas de inspección de tráfico como Suricata funcionan junto con configuraciones básicas de firewall para detectar y registrar actividades sospechosas, como ataques DoS o escaneos de puertos.  

Aunque minimalista, esta configuración es ideal para ser extendida a integraciones con sistemas SIEM/EDR/SOAR o para realizar análisis forense de red más avanzados.

## Capturas de Pantalla

*Img 1: Dirección IP estática*<br>
![1 targetvm_staticIP](https://github.com/user-attachments/assets/e64120f1-f65c-495a-a1ee-72592abfa018)

*Img 2: Verificación por terminal*<br>
![2 targetvm_IP](https://github.com/user-attachments/assets/14bb550f-c5bc-4b5d-836b-2d4b3b4942e3)

*Img 3: Firewall Script*<br>
![3 target_firewall_sp](https://github.com/user-attachments/assets/5d13ee03-a71d-48bc-950e-753a81a223ce)

*Img 4: Reglas del firewall Iptables*<br>
![4 iptables_sp](https://github.com/user-attachments/assets/540558df-7ddf-4bcb-bea0-5b4ee8bbbe95)

*Img 5: Permiso de ejecución al script de Iptables*<br>
![5 iptables_execm](https://github.com/user-attachments/assets/ca32a43f-c939-4d25-8f68-5ac535125835)

*Img 6: Revisar Firewall*<br>
![6 checking_iptables](https://github.com/user-attachments/assets/09ade55f-f073-42db-babf-cb01c8c09bad)

*Img 7: Guardar configuración actual del Firewall*<br>
![7 saving_iptablesconf](https://github.com/user-attachments/assets/4092b8ed-484a-40ca-822b-08c6cf3ccf55)

*Img 8 & 9: Actualizar Suricata junto con sus fuentes de reglas*<br>
![8 updating_suricata](https://github.com/user-attachments/assets/e54d863a-ec92-457a-8b7b-8f447120b74b)
![9 updating_sources](https://github.com/user-attachments/assets/34a1339b-e383-4b60-920a-489b4ea2fdaf)

*Img 10: Reglas de Suricata*<br>
![10 suricata_ls_rules](https://github.com/user-attachments/assets/5f8727c9-9496-4cea-8cc6-99588103a00b)

*Img 11 & 12: Reglas de Ping Flood y Port Scanning*<br>
![11 suricata_ping_rules](https://github.com/user-attachments/assets/2f63a61c-e239-4350-9a15-88e6e88859f1)
![12 suricata_port_rules](https://github.com/user-attachments/assets/5dd23d91-107b-4ae6-8d6b-1c03356106a4)

*Img 13 & 14: Agregar las reglas al archivo suricata.yaml y ejecutar Suricata en modo prueba*<br>
![13 adding_rules_to_suri_file](https://github.com/user-attachments/assets/677974e4-b191-47e4-9b3a-5fd61ee503e4)
![14 running_suricata_test_mode](https://github.com/user-attachments/assets/af5bddfb-b624-4420-b0d4-0dc9f6c5c7c2)

*Img 15: Dirección estática de la máquina atacante*<br>
![15 attackervm_staticIP](https://github.com/user-attachments/assets/fdca68d6-a0e1-4757-823b-252793126768)

*Img 16: Verificación por terminal*<br>
![16 ip_cmd](https://github.com/user-attachments/assets/c852c14f-6acd-4074-93c5-a15b03833250)

*Img 17: Ping-Flood Script*<br>
![17 flood_script](https://github.com/user-attachments/assets/67f3cb0a-920f-4999-81a4-ae6e61102d05)

*Img 18: Port-Scanning Script*<br>
![18 nmap_sp](https://github.com/user-attachments/assets/d2e72318-82ba-4e53-9318-335331b5dfa6)

*Img 19: Dar permisos de ejecución a ambos scripts*<br>
![18 1 both_executablescripts](https://github.com/user-attachments/assets/3af3dd15-19f5-4435-be9d-319b55c184d6)

*Img 20: Ejecutar Suricata y revisar los registros en tiempo real*<br>
![19 running_suricata_and_logs](https://github.com/user-attachments/assets/9ed79709-141b-42c8-ab5f-10ad425275d3)

*Img 21: Ejecutar script Port-Scanning*<br>
![20 attacker_port_scanning_sp](https://github.com/user-attachments/assets/c41511c3-92b2-418b-b263-746dde0d6cfa)

*Img 22: Alerta SYN detectada*<br>
![21 suricata_syn_alert](https://github.com/user-attachments/assets/dd739abb-1f7a-4734-b204-cb8c94dd2452)

*Img 23: Alerta FIN detectada*<br>
![22 suricata_fin_alert](https://github.com/user-attachments/assets/5ae36d70-c1ee-4fa3-97ac-b53bffe41a9d)

*Img 24: Alerta NULL detectada*<br>
![23 suricata_null_alert](https://github.com/user-attachments/assets/061896ff-11f7-4b88-85d7-7a50d8c7996d)

*Img 25: Alerta XMAS detectada*<br>
![24 suricata_xmas_alert](https://github.com/user-attachments/assets/c7c1519c-142f-4ea9-928f-ab5c5af3eb4a)

*Img 26: Alerta UDP detectada*<br>
![25 suricata_udp_alert](https://github.com/user-attachments/assets/4351cf43-779e-4fa6-80ed-1b837fcd676c)

*Img 27 & 28: Ejecutar script Ping-Flood*<br>
![26 attacker_flood_script](https://github.com/user-attachments/assets/81d0a433-7302-4ba0-9b10-1e4c276c4ca2)
![27 attacker_flood_script2](https://github.com/user-attachments/assets/a7ce8b0c-e1ab-4bd8-a56a-99acde784892)

*Img 29 & 30: Alertas de ICMP y Ping-Flood detectadas*<br>
![28 suricata_flood_alert1](https://github.com/user-attachments/assets/03a906d0-292a-4659-bc81-b85618afc4ee)
![29 suricata_flood_alert2](https://github.com/user-attachments/assets/d192d374-562f-4e79-b81f-60210906523b)

*Img 31: Revisar el tráfico capturado por el Firewall*<br>
![30 iptables_captured_traffic](https://github.com/user-attachments/assets/4299b965-bd4e-41c4-8cf1-f39b962011f4)

## 🛡️ Declaración de Seguridad y Ética

Todas las actividades demostradas en este proyecto están estrictamente confinadas a un entorno de laboratorio virtual, bajo control total y sin conexión a redes o sistemas externos.  
Este proyecto simula comportamientos maliciosos como ataques DoS y escaneo de puertos **únicamente con el propósito de aprender a detectar, analizar y responder a dichos eventos** utilizando herramientas defensivas como Suricata e iptables.

Como aspirante a profesional de la ciberseguridad, me adhiero a los principios de la ética del hacking:

- **No** realizo pruebas o escaneos no autorizados en redes o sistemas reales.
- Creo en el **uso responsable del conocimiento** para mejorar la postura de seguridad de los sistemas, no para explotarla.
- Mi objetivo es **aprender**, **compartir conocimiento** y **contribuir** a un mundo digital más seguro.

Si planeas reutilizar o adaptar este laboratorio, asegúrate de hacerlo dentro de un entorno aislado y **nunca** apuntes a sistemas sin permiso explícito.

#### ⚠️ Descargo de responsabilidad

Este proyecto está destinado **exclusivamente a fines educativos y de investigación**.  
Todas las simulaciones, incluidos los ataques DoS y el escaneo de puertos, se llevan a cabo en un **entorno de laboratorio controlado** utilizando **máquinas virtuales**.

**No utilices** estas técnicas en sistemas o redes que no poseas o para los cuales no tengas permiso explícito.
