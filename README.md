# Análise de Dados de Criminalidade em Vancouver

## Visão Geral

Este projeto realiza uma análise de dados de criminalidade em Vancouver usando duas tabelas diferentes para entender melhor a distribuição de crimes e a influência do tratamento de privacidade nos dados. A análise inclui a criação de visualizações de dados e a comparação entre os conjuntos de dados com diferentes níveis de privacidade.

## Tabelas Utilizadas

1. **VancouverCrimesWithoutPrivacy**
   - Contém detalhes completos sobre os crimes.
   - Colunas: `TYPE`, `DATECRIME`, `HUNDRED_BLOCK`, `NEIGHBOURHOOD`, `Latitude`, `Longitude`

2. **VancouverCrimesPrivacy**
   - Contém dados com tratamento de privacidade mais rigoroso.
   - Colunas: `TYPE`, `DATECRIME`, `HUNDRED_BLOCK` (valor fixo 'OFFSET TO PROTECT PRIVACY')

## Análise Realizada

- **Distribuição Espacial de Crimes:** Mapeamento da densidade de crimes por latitude e longitude.
- **Padrões Temporais:** Análise de tendências ao longo dos meses e identificação de padrões sazonais.
- **Comparação de Tipos de Crimes:** Comparação da frequência dos tipos de crimes entre as duas tabelas.
- **Consistência dos Dados:** Verificação da integridade e consistência dos dados entre as tabelas.

## Consultas SQL

Aqui estão algumas consultas SQL usadas para análise:

### Total de Crimes

```sql
SELECT 
    'Total' AS category,
    COUNT(*) AS total_crimes
FROM (
    SELECT DATECRIME FROM VancouverCrimesWithoutPrivacy
    UNION ALL
    SELECT DATECRIME FROM VancouverCrimesPrivacy
) AS combined_crimes;
```

### Distribuição de Tipos de Crimes

```sql
SELECT 
    TYPE,
    COUNT(*) AS crime_count
FROM VancouverCrimesWithoutPrivacy
GROUP BY TYPE
ORDER BY crime_count DESC;
```

### Comparação de Frequência de Tipos de Crimes

```sql
SELECT 
    TYPE,
    SUM(CASE WHEN source = 'Without Privacy' THEN crime_count ELSE 0 END) AS count_without_privacy,
    SUM(CASE WHEN source = 'With Privacy' THEN crime_count ELSE 0 END) AS count_with_privacy
FROM (
    SELECT 
        TYPE,
        COUNT(*) AS crime_count,
        'Without Privacy' AS source
    FROM VancouverCrimesWithoutPrivacy
    GROUP BY TYPE

    UNION ALL

    SELECT 
        TYPE,
        COUNT(*) AS crime_count,
        'With Privacy' AS source
    FROM VancouverCrimesPrivacy
    GROUP BY TYPE
) AS combined_crimes
GROUP BY TYPE
ORDER BY count_without_privacy DESC, count_with_privacy DESC;
```

## Dashboard

O projeto inclui um dashboard no Grafana que visualiza os resultados da análise. A imagem do dashboard é exibida para fornecer uma visão geral das descobertas, incluindo a distribuição de crimes por localização e padrões sazonais.

![screencapture-localhost-3000-d-ddulxezgsjrwgf-vancouver-crimes-2024-08-12-18_16_44](https://github.com/user-attachments/assets/d4f22c36-4b88-4ea6-a74b-33cd461b92a1)


## Como Usar

1. **Configuração do Ambiente:**
   - Certifique-se de que você tem o Grafana e MySQL configurados em seu ambiente.
   - Importe as consultas SQL no seu banco de dados MySQL.

2. **Configuração do Grafana:**
   - Configure a conexão com o banco de dados MySQL no Grafana.
   - Crie painéis usando as consultas fornecidas para gerar visualizações.

3. **Visualização:**
   - Utilize os painéis de mapa de calor, gráficos de barras e gráficos de linhas para explorar os dados.

## Contribuições

Sinta-se à vontade para contribuir com o projeto! Se você encontrar problemas ou tiver sugestões, por favor, abra uma issue ou envie um pull request.

## Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).
