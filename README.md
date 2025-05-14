VIVO DESAFIO!!!!

Aplicativo Flutter para busca de usuários do GitHub, exibição de informações detalhadas, filtros personalizados e gráficos de commits dos repositórios.

## Escolhas Técnicas e Trade-offs

| Item | Escolha | Justificativa |
|:-----|:--------|:--------------|
| Framework | Flutter | Escolhido por ser multiplataforma (Android, iOS, Web) e proporcionar alta produtividade no desenvolvimento de UI. |
| HTTP Client | Dio | Mais robusto e flexível que o pacote http nativo, permitindo interceptadores e melhor controle de erros. |
| Gerenciamento de Estado | flutter_bloc (Cubit) | Controle previsível e escalável de estados, mantendo o código desacoplado e testável. |
| Cache Local | SharedPreferences | Solução leve e rápida para armazenar o histórico de buscas sem necessidade de bancos complexos. |
| Gráficos | fl_chart | Biblioteca eficiente para renderizar gráficos com commits, de forma responsiva e personalizável. |

Trade-offs:
- A API pública do GitHub sem autenticação limita a 60 requisições por hora. Em produção, o ideal seria usar OAuth para aumentar o limite.
- SharedPreferences é excelente para cache leve, mas para armazenar histórico extenso ou dados complexos, seria melhor usar Hive ou Drift futuramente.

## Como rodar a aplicação

# Clone o repositório
git clone https://github.com/wesleychrispim/vivo_desafio_github_searcher.git

# Acesse o diretório do projeto
cd vivo_desafio_github_searcher

# Instale as dependências
flutter pub get

# Rode a aplicação
flutter run

## Como rodar os testes

# Execute o comando abaixo para rodar os testes unitários do SearchCubit
flutter test lib/modules/search/cubits/search_cubit_test.dart

## Propostas para escalabilidade futura

- Migrar o cache de histórico de buscas de SharedPreferences para Hive ou Drift, caso o volume de dados aumente.
- Implementar autenticação OAuth2 para a API do GitHub, permitindo um número maior de requisições por hora e acesso a dados privados.
- Melhorar o gráfico para trazer estatísticas de linguagens usadas nos repositórios, além dos commits.
- Implementar paginação e busca incremental de repositórios para usuários com muitos projetos.
- Aplicar arquitetura Clean Architecture separando camadas de Data, Domain e Presentation.
- Internacionalizar a aplicação para outros idiomas (i18n).

## Desafios enfrentados e como foram resolvidos

| Desafio | Solução |
|:--------|:--------|
| Limite de requisições da API pública do GitHub | Redução de chamadas desnecessárias utilizando cache de histórico local. |
| Montar gráficos visuais claros para usuários com muitos repositórios | Divisão automática dos repositórios em grupos de 5 e criação de múltiplos gráficos. |
| Falta de informações de linguagem no usuário | Implementação de busca específica nos repositórios para validar a linguagem. |
| Responsividade | Uso de widgets adaptativos como Expanded, ListView e tamanho dinâmico para telas móveis e web. |
| Controle de estados com múltiplas etapas de busca | Uso de Cubit para gerenciar estados de carregamento, sucesso e falha de forma clara e testável. |