# Руководство по переменным (Environment Variables & Config)

Для успешного развертывания проекта в новой инфраструктуре (GitLab, Yandex Cloud, Nexus) необходимо настроить следующие переменные.

## 1. Terraform (Yandex Cloud)
Файл: `infrastructure/terraform/terraform.tfvars` или переменные окружения `TF_VAR_*`.

| Переменная | Описание | Пример |
|------------|----------|---------|
| `yc_token` | OAuth токен для доступа к Yandex Cloud | `y0_AgAAAA...` |
| `yc_cloud_id` | ID облака Yandex Cloud | `b1g...` |
| `yc_folder_id` | ID каталога в Yandex Cloud | `b1g...` |
| `service_account_id` | ID сервисного аккаунта с правами `editor` | `aje...` |

**Terraform Backend (S3):**
В `infrastructure/terraform/main.tf` в блоке `backend "s3"` нужно изменить:
- `bucket`: Имя вашего существующего бакета для хранения стейта.

## 2. GitLab CI/CD Variables
Настраиваются в GitLab: *Settings -> CI/CD -> Variables*.

| Переменная | Описание |
|------------|----------|
| `YC_TOKEN` | OAuth токен Yandex Cloud (для деплоя). |
| `NEXUS_URL` | URL вашего Nexus репозитория. |
| `NEXUS_USER` | Логин в Nexus. |
| `NEXUS_PASSWORD` | Пароль в Nexus. |
| `KUBECONFIG` | Содержимое файла конфигурации kubectl (base64 или файл). |
| `MOMO_IMAGES_BASE_URL` | Базовый URL для статических изображений в S3. |

## 3. Helm Chart (values.yaml)
Файл: `infrastructure/helm/momo-store/values.yaml`

| Путь в YAML | Описание |
|-------------|----------|
| `backend.image.repository` | Полный путь к образу бэкенда в вашем Registry. |
| `frontend.image.repository` | Полный путь к образу фронтенда в вашем Registry. |
| `ingress.host` | Доменное имя, по которому будет доступен сайт. |

## 4. Frontend (VUE_APP_API_URL)
Если API доступно по адресу, отличному от `/api`, необходимо настроить переменную окружения при сборке фронтенда (в Dockerfile или пайплайне):
- `VUE_APP_API_URL`: URL бэкенда.

## 5. Nexus
Необходимо создать репозиторий типа `helm (hosted)` с именем, указанным в переменной `NEXUS_REPO` в `.gitlab-ci.yml` (по умолчанию `momo-store-helm`).
