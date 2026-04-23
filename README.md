# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

## Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

## Backend

```bash
go run ./cmd/api
go test -v ./...
```

---

# Дипломный проект: Инфраструктура Momo Store

Этот проект включает полную настройку CI/CD, IaC и оркестрации для приложения Momo Store.

## Состав репозитория

- `backend/`: Бэкенд на Go + Dockerfile.
- `frontend/`: Фронтенд на Vue.js + Dockerfile.
- `infrastructure/`:
  - `terraform/`: Ресурсы Yandex Cloud (K8s, VPC, S3, Registry).
  - `helm/`: Чарт для деплоя в Kubernetes.
- `.gitlab-ci.yml`: CI/CD пайплайн.
- `VARIABLES.md`: Список всех переменных, необходимых для настройки.

## Инструкции

Подробные инструкции по развертыванию и настройке переменных находятся в файлах `VARIABLES.md` и в разделах ниже.

### Развертывание инфраструктуры (Terraform)
1. Настройте переменные в `infrastructure/terraform/terraform.tfvars`.
2. `terraform init && terraform apply`.

### Развертывание приложения (Helm)
1. Обновите `infrastructure/helm/momo-store/values.yaml` (хост, теги образов).
2. `helm upgrade --install momo-store ./infrastructure/helm/momo-store`.
