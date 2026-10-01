# CI/CD MuleSoft — Processo de desenvolvimento, publicação e implantação

![Mule CI/CD Pipeline](mule-cicd-pipeline-1x1.png)

**Documento operacional para equipes de desenvolvimento, qualidade, integração e suporte**  
**Última validação:** 22 de setembro de 2026  
**Escopo:** `garrafeira-erp-proc-api` e `garrafeira-artsoft-sys-api`

---

## 1. Objetivo

Este documento descreve o processo de CI/CD utilizado nas aplicações MuleSoft da Garrafeira Soares, desde a criação de uma branch de desenvolvimento até a publicação do artefato no Anypoint Exchange e a implantação no CloudHub 2.0.

O processo busca garantir que:

- o código seja validado antes da promoção;
- o artefato implantado seja identificável e imutável;
- a mesma versão possa ser promovida entre ambientes;
- QUA receba atualizações somente após revisão e merge;
- credenciais e parâmetros de ambiente permaneçam fora do código-fonte;
- seja possível rastrear qual commit, versão e configuração foram implantados.

> **Resumo:** o GitHub controla o código e o fluxo de aprovação; o Maven constrói e testa; o Anypoint Exchange armazena versões imutáveis da aplicação; o CloudHub 2.0 executa a aplicação.

---

## 2. Aplicações cobertas

| Aplicação | Tipo | Repositório GitHub | Versão em `develop`/`qa` na validação |
|---|---|---|---:|
| Garrafeira ERP Process API | Process API | `it-garrafeirasoares/garrafeira-erp-proc-api` | `1.0.48` |
| Garrafeira ARTSOFT System API | System API | `it-garrafeirasoares/garrafeira-artsoft-sys-api` | `1.0.10` |

As duas aplicações utilizam o mesmo modelo de promoção nas branches `develop` e `qa`. A PROC mantém propriedades adicionais específicas de sincronização:

- `PRODUCTS_SYNC_MANUAL_ENABLED`;
- `THIRD_PARTIES_SYNC_MANUAL_ENABLED`.

---

## 3. Conceitos fundamentais

### 3.1 CI — Continuous Integration

**Continuous Integration** significa **Integração Contínua**. O objetivo é validar automaticamente alterações integradas ao repositório.

Neste processo, CI inclui:

- checkout do código;
- preparação do Java 17 e Maven;
- autenticação no Exchange para resolver dependências privadas;
- execução dos testes MUnit;
- geração dos relatórios de teste e cobertura configurados no projeto.

### 3.2 CD — Continuous Delivery/Deployment

**Continuous Delivery** significa **Entrega Contínua** e **Continuous Deployment**, **Implantação Contínua**.

Neste processo, CD inclui:

- publicação do JAR Mule no Exchange;
- abertura automática do PR `develop → qa`;
- aprovação humana para promoção;
- implantação automática em QUA após o merge em `qa`.

### 3.3 Artefato

O **artefato** é o JAR Mule gerado pelo Maven. Ele contém o código executável da aplicação e é identificado pelas coordenadas:

```text
groupId:artifactId:version
```

Exemplo conceitual:

```text
0feb...:garrafeira-erp-proc-app:1.0.48
```

### 3.4 Exchange versus CloudHub

| Componente | Responsabilidade |
|---|---|
| Anypoint Exchange | Armazenar e versionar o artefato da aplicação |
| CloudHub 2.0 | Executar a aplicação em um ambiente MuleSoft |
| Runtime Manager | Gerenciar configuração, implantação, logs, réplicas e endpoint |

Publicar no Exchange não significa que a aplicação já está executando. Implantar no CloudHub não significa necessariamente publicar uma versão nova no Exchange.

---

## 4. Estratégia de branches

```text
feature/*
    │
    │ desenvolvimento e testes locais
    ▼
develop
    │
    │ CI + publicação no Exchange
    │ PR automático
    ▼
qa
    │
    │ deploy automático em CloudHub QUA
    ▼
testes de qualidade
    │
    │ promoção controlada
    ▼
main
    │
    ▼
produção
```

### Responsabilidade de cada branch

| Branch | Finalidade | Implantação automática |
|---|---|---:|
| `feature/*` | Desenvolvimento isolado | Não |
| `develop` | Integração do código e publicação do artefato | Não implanta; publica no Exchange |
| `qa` | Versão aprovada para qualidade | Sim, em QUA |
| `main` | Linha estável de produção | Não está equalizada no modelo moderno; consulte a seção de produção |

---

## 5. Fluxo atual detalhado

## 5.1 Desenvolvimento em `feature/*`

O desenvolvedor deve criar sua branch a partir da `develop` atualizada:

```bash
git switch develop
git pull origin develop
git switch -c feature/nome-da-alteracao
```

Durante o desenvolvimento:

1. implementar a alteração;
2. executar testes locais;
3. criar ou atualizar testes MUnit;
4. verificar se nenhuma credencial foi adicionada ao Git;
5. atualizar a versão da aplicação no `pom.xml` quando o código resultar em um novo binário;
6. enviar a branch e integrar a alteração em `develop` conforme a política do repositório.

## 5.2 Pull Request direcionado a `develop`

O workflow `deploy-cloudhub.yml` é acionado em PRs cujo destino é `develop`.

Nesse evento, somente o job de validação é executado:

```text
Pull Request para develop
        ↓
Checkout
        ↓
Configuração Java 17 + Maven
        ↓
Autenticação para dependências do Exchange
        ↓
MUnit
```

Comando equivalente executado pelo pipeline:

```bash
mvn -B test \
  -Denv="$RUNTIME_ENV" \
  -Dencrypt.key="$MULE_ENCRYPT_KEY"
```

O PR não publica o artefato e não faz deploy.

## 5.3 Push ou merge em `develop`

Após a alteração entrar em `develop`, dois workflows são disparados.

### Workflow A — validação e publicação

```text
Push em develop
      ↓
MUnit
      ↓ sucesso
Publicação da versão no Exchange
```

Comando de publicação:

```bash
mvn -B clean deploy \
  -DskipTests \
  -Daether.connector.basic.parallelPut=false
```

Os testes são executados antes, em um job separado. O parâmetro `-DskipTests` evita repeti-los durante a publicação.

### Workflow B — abertura de PR para QUA

O workflow `open-pr-develop-to-qa.yml`:

1. verifica se já existe um PR aberto de `develop` para `qa`;
2. se existir, não cria duplicidade;
3. se não existir, cria automaticamente o PR com o título `Promote develop to qa`.

> A criação automática do PR não significa aprovação automática. A equipe deve revisar e efetuar o merge.

## 5.4 Merge em `qa`

O push resultante do merge em `qa` executa somente o job de implantação.

```text
Merge em qa
    ↓
Lê groupId, artifactId e version do pom.xml
    ↓
Confirma que o artefato existe no Exchange
    ↓
Envia o pedido de deploy ao CloudHub 2.0 QUA
```

Antes do deploy, o pipeline valida a existência do artefato:

```bash
mvn -B dependency:get \
  -Dartifact="$GROUP_ID:$ARTIFACT_ID:$VERSION:jar:mule-application" \
  -Dtransitive=false
```

Se a versão não existir no Exchange, o deploy é interrompido. Isso impede a implantação de uma versão não publicada.

O pedido de implantação utiliza:

```bash
mvn -B mule:deploy
```

com as credenciais, o ambiente, o target, o nome da aplicação e as propriedades de runtime provenientes do GitHub Environment `qa`.

---

## 6. Versionamento

## 6.1 Versão da aplicação/JAR

A versão principal localizada no `pom.xml` identifica o artefato executável:

```xml
<version>1.0.48</version>
```

Uma versão publicada no Exchange é imutável. Não é permitido substituir o conteúdo de uma versão existente.

```text
Primeira publicação de 1.0.48 → sucesso
Nova publicação de 1.0.48     → falha: asset já existente
```

Por isso, alterações de código que produzam um novo JAR devem utilizar uma versão ainda não publicada.

### Regra recomendada

| Tipo de mudança | Exemplo |
|---|---|
| Correção compatível | `1.0.48 → 1.0.49` |
| Nova funcionalidade compatível | `1.0.49 → 1.1.0` |
| Mudança incompatível | `1.1.0 → 2.0.0` |

## 6.2 Versão RAML

A versão RAML é independente da versão do JAR.

```text
JAR da aplicação: 1.0.10
RAML utilizado:   1.0.59
```

Atualizar a versão RAML não atualiza automaticamente a versão da aplicação, e vice-versa.

## 6.3 Quando não é necessária uma nova versão

Uma versão nova do JAR normalmente não é necessária quando ocorre apenas:

- alteração de secret;
- alteração de variável do ambiente;
- reinício da aplicação;
- ajuste de réplica ou configuração de infraestrutura;
- reimplantação da mesma versão;
- rollback para um artefato já publicado.

---

## 7. MUnit

MUnit é o framework de testes para aplicações Mule.

### Estado atual

| Projeto | Plugin MUnit configurado | Suíte versionada em `develop` |
|---|---:|---:|
| SYS | Sim | Sim — `garrafeira-artsoft-sys-api-suite.xml` |
| PROC | Sim | Não |

> **Limitação conhecida:** na PROC, o job Maven é executado, mas não há atualmente uma suíte XML em `src/test/munit`. Portanto, o sucesso do job não comprova cobertura funcional até que testes sejam adicionados e versionados.

### Estrutura esperada

```text
src/test/munit/
└── nome-da-api-suite.xml

src/test/resources/
├── log4j2-test.xml
└── dados-e-scripts-de-teste/
```

### Boas práticas

- mockar chamadas externas;
- não depender de dados variáveis de QUA;
- validar payload, atributos, variáveis e chamadas;
- evitar secrets diretamente nos testes;
- manter testes determinísticos;
- impedir promoção quando um teste obrigatório falhar.

---

## 8. GitHub Environments, variables e secrets

O pipeline moderno de `develop` e `qa` utiliza o GitHub Environment:

```text
qa
```

### Variables

| Variable | Finalidade |
|---|---|
| `ANYPOINT_ENVIRONMENT` | Nome do ambiente no Anypoint Platform |
| `ANYPOINT_TARGET` | Private Space ou target do CloudHub 2.0 |
| `ANYPOINT_BUSINESS_GROUP_ID` | ID do Business Group |
| `ANYPOINT_APP_NAME` | Nome estável da aplicação no Runtime Manager |
| `MULE_ENV` | Sufixo do arquivo de configuração, por exemplo `qua` |
| `MULE_API_ID` | ID de Autodiscovery no API Manager |
| `ANYPOINT_PLATFORM_BASE_URI` | URL base regional da plataforma |
| `ANYPOINT_PLATFORM_ANALYTICS_BASE_URI` | URL regional de ingestão de analytics |
| `ANYPOINT_PLATFORM_VISUALIZER_LAYER` | Camada exibida no Anypoint Visualizer |
| `PRODUCTS_SYNC_MANUAL_ENABLED` | Controle específico da PROC |
| `THIRD_PARTIES_SYNC_MANUAL_ENABLED` | Controle específico da PROC |

### Secrets

| Secret | Finalidade |
|---|---|
| `ANYPOINT_CLIENT_ID` | Connected App usada pelo CI/CD para Exchange e deploy |
| `ANYPOINT_CLIENT_SECRET` | Segredo da Connected App do CI/CD |
| `MULE_PLATFORM_CLIENT_ID` | Credencial utilizada pela aplicação em runtime/API Manager |
| `MULE_PLATFORM_CLIENT_SECRET` | Segredo utilizado pela aplicação em runtime/API Manager |
| `MULE_ENCRYPT_KEY` | Chave das Secure Configuration Properties |

> As credenciais do CI/CD e as credenciais de runtime têm responsabilidades diferentes. Não devem ser consideradas intercambiáveis.

### Segurança

- nunca colocar secrets no YAML, `pom.xml` ou arquivos versionados;
- usar proteção de ambiente para produção;
- aplicar menor privilégio à Connected App;
- rotacionar secrets conforme política interna;
- revisar logs antes de compartilhá-los externamente;
- não imprimir valores secretos; apenas validar presença.

---

## 9. Configuração do CloudHub 2.0

Os POMs atuais configuram o deployment CloudHub 2.0 com os seguintes princípios:

```text
Réplicas:             1
Tamanho:              mule.nano
Estratégia:           rolling
URL pública padrão:   habilitada
Java:                 17
Canal:                EDGE
```

### Rolling update

`rolling` tenta substituir a configuração progressivamente. Com uma única réplica e capacidade Nano, a plataforma ainda precisa inicializar o novo pod e validar os containers antes de concluir a troca.

### Verificação assíncrona

O pipeline utiliza:

```text
skipDeploymentVerification=true
```

Assim, o GitHub Actions termina depois que o pedido de deployment é aceito. Um pipeline verde não confirma sozinho que a aplicação alcançou `RUNNING`.

Após o pipeline, é obrigatório verificar no Runtime Manager:

- status `Running`;
- `1 / 1 replicas started`;
- endpoint público habilitado, quando aplicável;
- ausência de erros de API Manager;
- logs de inicialização;
- health check ou chamada funcional.

---

## 10. Produção — estado atual e restrição

Os workflows de `develop` e `qa` estão equalizados entre PROC e SYS. Os workflows existentes em `main` ainda são versões anteriores e não estão totalmente alinhados ao modelo moderno.

### PROC em `main`

- execução manual por `workflow_dispatch`;
- permite escolher `develop`, `qa` ou `main` como GitHub Environment;
- permite publicação opcional no Exchange;
- não possui a mesma separação de jobs;
- não executa MUnit no workflow atual de `main`.

### SYS em `main`

- mantém execução automática associada a `qa` e execução manual;
- permite escolher `qa` ou `main`;
- executa MUnit no workflow legado;
- ainda não corresponde exatamente ao workflow moderno de `develop`/`qa`.

> **Orientação:** até a equalização formal de produção, qualquer implantação em `main` deve ser tratada como uma operação controlada, com confirmação da versão, revisão das variables/secrets e validação posterior no Runtime Manager.

---

## 11. Procedimento operacional diário

### Desenvolvedor

1. atualizar `develop`;
2. criar `feature/*`;
3. implementar e testar;
4. criar ou atualizar MUnit;
5. verificar a versão do `pom.xml`;
6. confirmar que a versão ainda não existe no Exchange;
7. integrar em `develop`;
8. acompanhar MUnit e publicação;
9. revisar o PR automático `develop → qa`.

### Revisor/Responsável por QUA

1. confirmar que o pipeline de `develop` terminou com sucesso;
2. confirmar a versão publicada no Exchange;
3. revisar o PR `develop → qa`;
4. realizar o merge;
5. acompanhar o deploy em `qa`;
6. validar o estado no Runtime Manager;
7. executar testes funcionais e de integração.

### Suporte/Operações

1. identificar aplicação, ambiente e versão;
2. consultar GitHub Actions;
3. consultar Runtime Manager e logs;
4. confirmar credenciais do runtime/API Manager;
5. avaliar rollback se a versão nova estiver defeituosa;
6. registrar evidências e resultado da intervenção.

---

## 12. Rollback

Rollback significa retornar a uma versão/configuração anteriormente estável.

### Opção preferencial — Runtime Manager

1. abrir a aplicação no Runtime Manager;
2. acessar o histórico de configurações;
3. identificar a última configuração estável;
4. selecionar a configuração anterior;
5. implantar novamente;
6. validar logs, réplica e endpoint.

### Regras

- não sobrescrever uma versão existente no Exchange;
- não reduzir o POM e tentar republicar o mesmo número;
- registrar qual versão apresentou falha;
- manter versões estáveis disponíveis enquanto forem necessárias para rollback;
- corrigir o código em nova versão após restaurar o serviço.

---

## 13. Diagnóstico de falhas comuns

| Sintoma | Causa provável | Ação |
|---|---|---|
| `401 Unauthorized` ao resolver dependências | Credenciais do Exchange ausentes ou incorretas | Validar `ANYPOINT_CLIENT_ID/SECRET` e permissões da Connected App |
| `An asset already exists with this version` | A versão do POM já foi publicada | Incrementar a versão; não sobrescrever |
| `dependency:get` não encontra o artefato | Versão do `qa` não foi publicada em `develop` | Confirmar POM e execução de publicação |
| Pipeline verde, aplicação não inicia | Deploy é assíncrono | Consultar Runtime Manager e logs |
| `Client ID and Client Secret could not be validated against API Manager` | Credenciais de runtime inválidas | Revisar `MULE_PLATFORM_CLIENT_ID/SECRET` |
| Endpoint público indisponível | Ingress/URL pública/configuração de deploy | Validar `generateDefaultPublicUrl`, ingress e status da aplicação |
| MUnit verde sem testes | Projeto não possui suíte versionada | Adicionar XML em `src/test/munit` |
| PR automático não é criado | Permissão do GitHub Actions ou PR já existente | Validar `pull-requests: write` e PR aberto |
| Deploy usa código antigo | Versão antiga reutilizada ou POM divergente | Conferir commit, versão e artefato do Exchange |

---

## 14. Critérios de sucesso

Uma entrega para QUA é considerada concluída somente quando:

- [ ] MUnit foi executado com sucesso;
- [ ] a versão correta foi publicada no Exchange;
- [ ] o PR `develop → qa` foi revisado e integrado;
- [ ] o job de deploy terminou sem erro;
- [ ] o Runtime Manager mostra a aplicação como `Running`;
- [ ] existe uma réplica iniciada;
- [ ] o endpoint esperado responde;
- [ ] a integração com API Manager está autenticada;
- [ ] os testes funcionais de QUA foram aprovados;
- [ ] versão, commit e evidências foram registrados.

---

## 15. Melhorias pendentes/recomendadas

1. equalizar os workflows de `main` com o modelo moderno;
2. criar suíte MUnit real para a PROC;
3. definir percentual mínimo de cobertura em vez de `0`;
4. adicionar validação explícita de versão antes de publicar;
5. criar estratégia formal de versionamento automático ou semiautomático;
6. adicionar health check posterior ao deploy;
7. registrar versão e commit implantados como evidência do pipeline;
8. proteger o GitHub Environment de produção com aprovação obrigatória;
9. documentar responsáveis e janela de implantação;
10. definir política de retenção/depreciação de versões do Exchange.

---

## 16. Glossário rápido

| Termo | Significado |
|---|---|
| CI/CD | Integração Contínua e Entrega/Implantação Contínua |
| Pipeline | Sequência automatizada de validação, publicação e deploy |
| Artifact | Artefato; pacote executável gerado pelo build |
| Deploy | Implantação de uma aplicação em um ambiente |
| Runtime | Ambiente/processo que executa a aplicação |
| Rollback | Retorno a uma versão anteriormente estável |
| Immutable | Imutável; não pode ser substituído depois de publicado |
| MUnit | Framework de testes unitários e de fluxo para Mule |
| Exchange | Catálogo e repositório de ativos MuleSoft |
| CloudHub 2.0 | Plataforma gerenciada para execução das aplicações Mule |
| PR/Pull Request | Solicitação de integração entre branches |

---

## 17. Resumo executivo do fluxo

```text
Desenvolvedor cria feature a partir de develop
                    ↓
              altera e testa
                    ↓
             PR/merge em develop
                    ↓
                  MUnit
                    ↓
      publicação da versão no Exchange
                    ↓
        PR develop → qa automático
                    ↓
             revisão e merge
                    ↓
         deploy automático em QUA
                    ↓
       validação no Runtime Manager
                    ↓
          testes funcionais de QUA
                    ↓
     promoção controlada para produção
```

**Princípio central:** construir e publicar uma versão identificável, revisar sua promoção e implantar o mesmo artefato nos ambientes seguintes.
