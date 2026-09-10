# PBL1-PDS
Repositório com códigos compatíveis com Octave da disciplina de MI - Processamento Digital de Sinais

# Análise comparativa do processo de amostragem para sinais analógicos de tempo contínuo

Este código realiza uma análise analítica de amostragem de sinais contínuos. Ele compara a amostragem ideal com a amostragem natural e topo-plano, demonstrando como esses métodos afetam o sinal e seu espectro.

O código utiliza funções de amostragem implementadas em arquivos separados (`src/idealSampling.m`, `src/naturalSampling.m` e `src/flatTopSampling.m`) para gerar os sinais amostrados.

A análise é realizada em diferentes domínios (tempo e frequência) e os resultados são plotados em gráficos para visualização. Além disso, o código também calcula e plota o espectro analítico dos sinais amostrados.