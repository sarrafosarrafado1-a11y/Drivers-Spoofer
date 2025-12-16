@echo off
title Limpeza FiveM
color 0A
echo.
echo [INFO] Iniciando limpeza do FiveM...

REM ==============================================
REM Verificar se está executando como administrador
REM ==============================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERRO] Execute como Administrador!
    echo.
    pause
    exit /b 1
)

REM ==============================================
REM 1. Limpar appdata/roaming/CitizenFX
REM ==============================================
echo.
echo [ETAPA 1/4] Limpando CitizenFX...
set "roamingPath=%appdata%\CitizenFX"

if exist "%roamingPath%\" (
    echo [INFO] Acessando: %roamingPath%
    
    REM Verificar e apagar pasta "kvs" se existir
    set "kvsPath=%roamingPath%\kvs"
    if exist "%kvsPath%\" (
        echo [EXCLUINDO] Pasta kvs...
        rmdir /s /q "%kvsPath%"
        if exist "%kvsPath%\" (
            echo [AVISO] Nao foi possivel excluir completamente a pasta kvs
        ) else (
            echo [OK] Pasta kvs excluida com sucesso
        )
    ) else (
        echo [INFO] Pasta kvs nao encontrada
    )
    
    REM Limpar outros arquivos temporarios no CitizenFX
    echo [INFO] Limpando arquivos temporarios...
    del /q "%roamingPath%\*.log" 2>nul
    del /q "%roamingPath%\*.tmp" 2>nul
    del /q "%roamingPath%\cache\*.*" 2>nul
) else (
    echo [INFO] Pasta CitizenFX nao encontrada
)

REM ==============================================
REM 2. Limpar appdata/local/FiveM
REM ==============================================
echo.
echo [ETAPA 2/4] Limpando FiveM...
set "localPath=%localappdata%\FiveM"

if exist "%localPath%\" (
    echo [INFO] Acessando: %localPath%
    
    REM Apagar FiveM.VisualElementsManifest.xml
    set "visualManifest=%localPath%\FiveM.VisualElementsManifest.xml"
    if exist "%visualManifest%" (
        echo [EXCLUINDO] FiveM.VisualElementsManifest.xml...
        del /q "%visualManifest%"
        echo [OK] Arquivo excluido
    ) else (
        echo [INFO] Arquivo FiveM.VisualElementsManifest.xml nao encontrado
    )
    
    REM Limpar pasta crash
    set "crashPath=%localPath%\FiveM.app\crashes"
    if exist "%crashPath%\" (
        echo [EXCLUINDO] Pasta crashes...
        rmdir /s /q "%crashPath%"
        echo [OK] Pasta crashes excluida
    )
    
    REM Limpar pasta logs
    set "logsPath=%localPath%\FiveM.app\logs"
    if exist "%logsPath%\" (
        echo [EXCLUINDO] Pasta logs...
        rmdir /s /q "%logsPath%"
        echo [OK] Pasta logs excluida
    )
    
    REM Limpar logs na raiz
    echo [INFO] Limpando logs da raiz...
    del /q "%localPath%\*.log" 2>nul
    del /q "%localPath%\*.log.*" 2>nul
    
) else (
    echo [INFO] Pasta FiveM nao encontrada
)

REM ==============================================
REM 3. Limpar data (exceto game-storage)
REM ==============================================
echo.
echo [ETAPA 3/4] Limpando pasta data...
set "dataPath=%localappdata%\FiveM\FiveM.app\data"

if exist "%dataPath%\" (
    echo [INFO] Acessando: %dataPath%
    
    REM Preservar a pasta game-storage
    set "gameStoragePath=%dataPath%\game-storage"
    
    echo [INFO] Preservando: game-storage
    
    REM Criar pasta temporaria
    set "tempPath=%temp%\FiveMTemp_%random%"
    mkdir "%tempPath%" >nul 2>&1
    
    REM Mover game-storage para temporario se existir
    if exist "%gameStoragePath%\" (
        echo [INFO] Movendo game-storage para local temporario...
        robocopy "%gameStoragePath%" "%tempPath%\game-storage" /E /MOVE >nul 2>&1
    )
    
    REM Apagar todo o conteudo da pasta data
    echo [EXCLUINDO] Conteudo da pasta data...
    rmdir /s /q "%dataPath%"
    
    REM Recriar pasta data
    mkdir "%dataPath%" >nul 2>&1
    
    REM Restaurar game-storage se foi movida
    if exist "%tempPath%\game-storage\" (
        echo [INFO] Restaurando game-storage...
        robocopy "%tempPath%\game-storage" "%dataPath%\game-storage" /E >nul 2>&1
    )
    
    REM Limpar pasta temporaria
    if exist "%tempPath%\" (
        rmdir /s /q "%tempPath%"
    )
    
    echo [OK] Pasta data limpa (game-storage preservado)
) else (
    echo [INFO] Pasta data nao encontrada
)

REM ==============================================
REM 4. Limpeza adicional e finalizacao
REM ==============================================
echo.
echo [ETAPA 4/4] Limpeza final...

REM Limpar cache do navegador embutido
set "cachePath=%localappdata%\FiveM\FiveM.app\cache"
if exist "%cachePath%\" (
    echo [INFO] Limpando cache...
    rmdir /s /q "%cachePath%"
    mkdir "%cachePath%" >nul 2>&1
)

REM Limpar pasta do servidor cache
set "serverCachePath=%appdata%\CitizenFX\cache\server"
if exist "%serverCachePath%\" (
    echo [INFO] Limpando cache do servidor...
    rmdir /s /q "%serverCachePath%"
)

REM Verificar se o FiveM está em execução
echo [INFO] Verificando processos do FiveM...
tasklist /FI "IMAGENAME eq FiveM*" /FO CSV 2>nul | find /I "FiveM" >nul
if %errorLevel% equ 0 (
    echo [AVISO] FiveM esta em execucao. Feche o FiveM antes de continuar.
    echo        Alguns arquivos podem nao ter sido excluidos completamente.
)

REM ==============================================
REM Finalizacao
REM ==============================================
echo.
echo ============================================
echo [SUCESSO] Limpeza concluida com sucesso!
echo.
echo Resumo das acoes:
echo 1. Pasta kvs (CitizenFX) - Excluida
echo 2. VisualElementsManifest.xml - Excluido
echo 3. Pastas crash e logs - Excluidas
echo 4. Pasta data limpa (game-storage preservado)
echo ============================================
echo.

REM Aguardar 3 segundos e fechar
timeout /t 3 /nobreak >nul

REM Se executado duplo-clique, manter aberto
if "%cmdcmdline:~0,5%"=="%comspec%" (
    pause
)
exit /b 0