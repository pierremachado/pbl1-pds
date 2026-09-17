function saveFigurePng(fig, filePath)
    % saveFigurePng - Salva uma figura em PNG com resolução consistente.
    set(fig, 'paperunits', 'inches');
    set(fig, 'papersize', [12 9]);
    set(fig, 'paperposition', [0 0 12 9]);
    print(fig, filePath, '-dpng', '-r120');
    fprintf('    Salvo: %s\n', filePath);
end
