function appendGifFrame(fig, gifPath, frameIndex)
    % appendGifFrame - Captura o frame atual da figura e o grava no GIF
    % em gifPath. Cria o arquivo no primeiro frame (frameIndex == 1) e
    % anexa (append) nos frames seguintes.
    %
    % Usa print para um PNG temporário e imwrite direto com a imagem RGB
    % (sem passar por rgb2ind), pois: (1) getframe não é implementado no
    % toolkit gnuplot usado pelo Octave sem interface gráfica Qt/FLTK;
    % (2) rgb2ind com paleta customizada requer o pacote 'image' do
    % Octave Forge, nem sempre disponível. imwrite converte a paleta
    % internamente tanto no MATLAB quanto no Octave.

    tmpFile = [tempname() '.png'];
    drawnow;
    print(fig, tmpFile, '-dpng', '-r100');
    im = imread(tmpFile);
    delete(tmpFile);

    if frameIndex == 1
        imwrite(im, gifPath, 'gif', 'LoopCount', inf, 'DelayTime', 0.15);
    else
        imwrite(im, gifPath, 'gif', 'WriteMode', 'append', 'DelayTime', 0.15);
    end
end
