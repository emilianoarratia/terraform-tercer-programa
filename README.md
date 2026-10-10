# Terraform Tercer Programa

Práctica independiente para desplegar cinco recursos Azure del entorno QA: Resource Group, Log Analytics Workspace, Application Insights, Linux App Service Plan F1 y Linux Web App Node.js.

## Origen

Código del profesor: https://github.com/jorgealmeidamontiel/terraform-laboratories/tree/main/tercer-programa

Revisión auditada: `9d0eb0eb0ec423248007a0df5e7031c29d138e8f`.

El primer commit conserva los tres archivos originales. No se modifica el repositorio del profesor ni segundo-programa.

## Ajustes

- Se elimina el valor ficticio GATO y se requiere un UUID de suscripción.
- AzureRM 4.62.0 y Terraform >= 1.13, < 2; lockfile versionado.
- Locals derivados de la convención del nombre original: utvt, integradora, web, qa, código de región e instancia 001.
- Se verificó Mexico Central para Linux F1, Log Analytics y Application Insights; el despliegue utilizó `mexicocentral` con el código `mxc`.
- Tags explícitos para proyecto, ambiente, administración y práctica. Son una decisión de implementación; el profesor no proporcionó valores de tags.
- Nombre Web App obligatorio para comprobar su disponibilidad global antes del despliegue.
- Outputs de nombres y URL; no se exportan claves ni connection strings.
- Exclusiones de estado, planes, tfvars, credenciales y temporales.
- Se conservan los cinco recursos, Node.js 24-lts, HTTPS, TLS 1.2, FTPS Disabled, always_on false, retención de 30 días y límites de ingesta de 0.1 GB.

## Ejecución después de autenticar Azure

Cuenta prevista: universitaria verificada. Confirmar la sesión actual; no confiar solamente en datos de una práctica anterior.

```powershell
az account show --query "{user:user.name,subscription:name,id:id,tenant:tenantId,state:state}" -o json
$env:TF_VAR_subscription_id = az account show --query id -o tsv
```

En Bash:

```bash
az account show --query '{user:user.name,subscription:name,id:id,tenant:tenantId,state:state}' -o json
export TF_VAR_subscription_id="$(az account show --query id -o tsv)"
```

Comprobar políticas, proveedores Microsoft.Web, Microsoft.Insights y Microsoft.OperationalInsights, disponibilidad F1 Linux, runtime y nombre Web App. La configuración desactiva el registro automático de proveedores para no registrar servicios ajenos a la práctica; registrar únicamente los tres indicados si faltan y la cuenta lo permite.

Copiar terraform.tfvars.example a terraform.tfvars y ajustar los valores a los resultados reales. No publicar terraform.tfvars.

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan -out=qa.tfplan
```

Antes de apply, comprobar de nuevo usuario/suscripción, cambios y costos. Un estado nuevo debería proponer los cinco recursos, pero el plan real es la única evidencia válida.

```bash
terraform apply qa.tfplan
terraform output
terraform plan -detailed-exitcode
```

Comprobar recursos y configuración mediante Azure CLI y Portal. La conexión a Application Insights en configuración no prueba recepción de telemetría: no se incluye una aplicación Node.js del alumno en esta práctica. No ejecutar destroy automáticamente.

## Resultados verificados

- fmt y fmt -check: exitosos.
- init y validate: exitosos en PowerShell local con Terraform 1.16.5 y AzureRM 4.62.0 firmado por HashiCorp. El lockfile incluye la selección de Windows.
- Cuenta universitaria universitaria verificada; Azure for Students, Enabled. El UUID se obtiene de la sesión y no se publica en la configuración.
- Plan real: 5 recursos por crear, 0 cambios, 0 eliminaciones.
- Apply real: 5 creados, 0 cambios, 0 eliminaciones.
- Plan posterior: No changes. Your infrastructure matches the configuration.
- Azure CLI comprobó Resource Group y recursos en Mexico Central, plan F1/Free, Web App Running, Node.js 24-lts, HTTPS obligatorio, TLS y SCM TLS 1.2, FTPS Disabled y always_on false.
- Log Analytics: Succeeded, PerGB2018, 30 días, cuota diaria 0.1 GB.
- Application Insights: Succeeded y conectado al workspace; ambas variables de integración existen en la Web App. No se afirma recepción de telemetría de una aplicación del alumno.
- Repositorio de entrega: https://github.com/emilianoarratia/terraform-tercer-programa
- Se conservan los recursos para revisión. No se ejecutó terraform destroy.

El plan F1 evita pasar automáticamente a un nivel de cómputo de pago. Log Analytics PerGB2018 y Application Insights pueden generar cargos por uso; sus límites diarios no son una garantía de costo cero.

## Referencias

- https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
- https://registry.terraform.io/providers/hashicorp/azurerm/4.62.0/docs
- https://registry.terraform.io/providers/hashicorp/azurerm/4.62.0/docs/resources/linux_web_app
- https://learn.microsoft.com/en-us/azure/app-service/quickstart-nodejs
- https://learn.microsoft.com/en-us/azure/azure-monitor/app/codeless-app-service
