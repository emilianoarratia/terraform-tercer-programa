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
- La región y su código se proporcionan tras verificar políticas y Linux F1. `mxc`/`mexicocentral` aparecen únicamente en el ejemplo.
- Tags explícitos para proyecto, ambiente, administración y práctica. Son una decisión de implementación; el profesor no proporcionó valores de tags.
- Nombre Web App obligatorio para comprobar su disponibilidad global antes del despliegue.
- Outputs de nombres y URL; no se exportan claves ni connection strings.
- Exclusiones de estado, planes, tfvars, credenciales y temporales.
- Se conservan los cinco recursos, Node.js 24-lts, HTTPS, TLS 1.2, FTPS Disabled, always_on false, retención de 30 días y límites de ingesta de 0.1 GB.

## Ejecución después de autenticar Azure

Cuenta prevista: al222310542@utvtol.edu.mx. Confirmar la sesión actual; no confiar solamente en datos de una práctica anterior.

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

## Estado real de esta copia

- fmt y fmt -check: exitosos.
- init: exitoso; AzureRM 4.62.0 firmado por HashiCorp.
- validate: bloqueado por restricción de socket Unix en el entorno de ejecución; no validado todavía.
- Azure account show: autenticación completada; cuenta al222310542@utvtol.edu.mx, Azure for Students, Enabled. El UUID se obtiene de la sesión y no se publica aquí.
- Azure incluye Mexico Central en ubicaciones de Linux F1, Application Insights y Log Analytics. Las consultas de políticas con y sin coincidencia estricta no devolvieron asignaciones visibles; no demuestra ausencia de restricciones no visibles.
- Azure list-runtimes confirma NODE|24-lts activo.
- Azure checknameavailability devuelve nameAvailable=true para app-utvt-integradora-web-qa-mxc-emiliano-001. Debe revisarse de nuevo antes de apply.
- Se solicitó el registro de Microsoft.Web, microsoft.insights y Microsoft.OperationalInsights; la última consulta muestra Registering.
- plan, apply y comprobación de recursos: pendientes de entorno compatible. No se ha creado infraestructura.
- Publicación GitHub y reporte final Word: pendientes.

El plan F1 evita pasar automáticamente a un nivel de cómputo de pago. Log Analytics PerGB2018 y Application Insights pueden generar cargos por uso; sus límites diarios no son una garantía de costo cero.

## Referencias

- https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
- https://registry.terraform.io/providers/hashicorp/azurerm/4.62.0/docs
- https://registry.terraform.io/providers/hashicorp/azurerm/4.62.0/docs/resources/linux_web_app
- https://learn.microsoft.com/en-us/azure/app-service/quickstart-nodejs
- https://learn.microsoft.com/en-us/azure/azure-monitor/app/codeless-app-service
