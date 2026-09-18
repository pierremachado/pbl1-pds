# PBL1-PDS

Repositório com códigos compatíveis com Octave da disciplina de MI - Processamento Digital de Sinais.

Este projeto visa resolver o desafio proposto à equipe de engenharia da **SigmaDSP Inc.**, consistindo na avaliação do teorema da amostragem de sinais analógicos de tempo contínuo, a primeira etapa da conversão Analógico/Digital. 

O código realiza uma análise analítica nos domínios do tempo e da frequência, comparando os três métodos clássicos de amostragem. As simulações demonstram como esses métodos afetam o sinal, seu espectro e os critérios estritos para a reconstrução do sinal original sem perda de informação.

## Tópicos Importantes Abordados

A partir da fundamentação teórica estudada, os códigos implementam os seguintes conceitos:

*   **Filtragem de Sinal:** Simulação da limitação em banda de um sinal para atenuar frequências indesejáveis e evitar a sobreposição.
*   **Teorema da Amostragem de Nyquist-Shannon:** A regra de que a frequência de amostragem deve ser maior que o dobro da frequência máxima do sinal para que ele possa ser unicamente determinado pelas suas amostras.
*   **Critério de Nyquist e Aliasing:** A demonstração visual (via variação da frequência de amostragem) do fenômeno de *aliasing*, que ocorre quando o critério de Nyquist não é atendido, resultando na sobreposição das réplicas espectrais e perda irrecuperável de informação original.
*   **Reconstrução do Sinal:** A recuperação do sinal original analógico aplicando filtros passa-baixas (para isolar a banda base) e os devidos ganhos/equalizações específicas para cada método.

## Métodos de Amostragem Analisados

1.  **Amostragem Ideal:** Método estritamente matemático onde o sinal é convertido em uma sequência de valores instantâneos, mapeado por impulsos ideais de duração nula. No domínio da frequência, gera réplicas perfeitas do espectro do sinal original.
2.  **Amostragem Natural:** O sinal contínuo é multiplicado por um trem de pulsos retangulares de largura finita. Durante a largura do pulso, a amostra acompanha a exata variação e formato do sinal original. Seu espectro apresenta réplicas do sinal original que sofrem ponderação.
3.  **Amostragem Instantânea de Topo Plano (Flat-Top):** O valor da amostra capturada é mantido constante durante todo o intervalo do pulso retangular, formando um "topo plano". Este método é mais factível fisicamente, mas introduz no espectro o chamado **efeito de abertura**, causando atenuação nas componentes de altas frequências que precisam ser corrigidas com um filtro equalizador na reconstrução.

## Estrutura do Projeto

O código modular utiliza funções de amostragem implementadas em arquivos separados para organizar a geração dos sinais:

*   `src/sampling` - Implementações dos métodos de amostragem.
*   `src/transform` - Implementação das transformadas de uma senoide a partir do cálculo analítico dos métodos de amostragem.
*   `src/reconstruction` - Implementação de algoritmo de reconstrução da Transformada Discreta de Fourier Inversa (IDFT) para visualização do sinal reconstruído no domínio do tempo e seu espectro no domínio da frequência.

## Funcionalidades e Resultados

*   **Geração de Sinais:** Criação de sinais senoidais com limitação de banda.
*   **Análise no Tempo:** Gráficos que comparam o sinal original com as amostras resultantes de cada método.
*   **Análise na Frequência:** Espectros analíticos que demonstram as réplicas espectrais, ponderações e o efeito de abertura.
*   **Ajuste Dinâmico:** Capacidade de ajustar a frequência de amostragem para observar claramente situações com e sem a ocorrência de *aliasing*.