CREATE OR REPLACE PROCEDURE CUSTOM.PR_IMPORTA_INVENTARIO(P_NMARQUIVO IN VARCHAR, P_INVENTARIO IN NUMBER) IS
  /*----------------------------------------------------------------------------------------------------------------------
    Objetivo: Recupera os dados do inventario enviado via TXT e atualiza as informacoes no BD

    Parâmetros: p_NmArquivo   => Nome do arquivo que será importado
                p_inventario  => Sequencial do inventário gerado
  ----------------------------------------------------------------------------------------------------------------------*/

  -- Variáveis
  V_FILE            UTL_FILE.FILE_TYPE; -- manipula os dados dos arquivos txt
  V_ROWN            VARCHAR2(4000); -- recebe os dados de uma linha do arquivo txt
  V_DADOS_LOJA      VARCHAR2(100); -- recebe a loja
  V_DADOS_DATA      DATE;   -- recebe a data
  V_DADOS_BARRA     VARCHAR2(13); -- recebe o codigo de barra
  V_DADOS_COD_INT   VARCHAR2(9); -- recebe o codigo interno
  V_DADOS_UNID_MEDI VARCHAR2(6); -- recebe o codigo interno
  V_DADOS_PRE_VEN   NUMBER(9); -- recebe o preco venda
  V_DADOS_QUANTID   NUMBER(8); -- recebe a quantidade de estoque
  V_CONT            NUMBER := 0; -- contador utilizado no loop para executar os commit's

BEGIN

  -- Realizando a conexão com o arquivo txt
  V_FILE := UTL_FILE.FOPEN('PATH_GERAL', P_NMARQUIVO, 'r');-- PATH_GERAL - objeto já criado no banco (i:\autorizacao\autorizacao\producao\geral)

  LOOP

    BEGIN

      -- Percorrendo o arquivo e inserindo os dados na variável v_rown, uma linha de cada vez
      UTL_FILE.GET_LINE(V_FILE, V_ROWN);

      -- Recuperando a loja
      V_DADOS_LOJA := SUBSTR(V_ROWN, 3, 4);

      -- Recuperando a data
      V_DADOS_DATA := TO_DATE(SUBSTR(V_ROWN, 7, 6),'MMDDYY');

      -- Recuperando o codigo de barra
      V_DADOS_BARRA := SUBSTR(V_ROWN, 13, 13);

      -- Recuperando o codigo interno
      V_DADOS_COD_INT := SUBSTR(V_ROWN, 26, 9);

      -- Recuperando o preco de venda
      V_DADOS_PRE_VEN := SUBSTR(V_ROWN, 35, 9);

      -- Recuperando o quantidade estoque
      V_DADOS_QUANTID := SUBSTR(V_ROWN, 44, 5);

      --atualizando ficha inventario
      UPDATE FARMEXT.FICHA_INVENTARIO FI
         SET FI.QTESTOCADACONTADA = TO_NUMBER(V_DADOS_QUANTID), FI.AODIGITADO = 'S', FI.CDDIGITADOR = 'RCATAIDE'
       WHERE FI.NRINVENTARIO = P_INVENTARIO --trocar pelo numero inventario correto
         AND lpad(FI.CDMATERIAL,9,0) = V_DADOS_COD_INT
         AND Fi.NRCONTAGEM = 1; --contagem correta

      -- Inserindo os dados recuperados no BD
       /*SELECT EM.CDUNIDADEMEDIDA
         INTO V_DADOS_UNID_MEDI
         FROM EMBALAGEM_MATERIAL EM
        WHERE EM.AOEMBALAGEMABCFARMA = 'S'
          AND EM.CDMATERIAL = V_DADOS_COD_INT
          AND ROWNUM = 1;
      INSERT INTO FICHA_INVENTARIO
        (NRINVENTARIO, -- 1
         NRFICHAINVENTARIO, -- 2
         CDMATERIAL, -- 3
         CDEMPRESA, -- 4
         CDDEPOSITO, -- 5
         CDLOCAL, -- 6
         CDTIPOESTOQUE, -- 7
         NRITEMMATERIAL, -- 8
         CDUNIDADEMEDIDA, -- 9
         QTESTOCADADASISTEMA, -- 10
         QTESTOCADACONTADA, -- 11
         NRCONTAGEM, -- 12
         AOVALIDADE, -- 13
         TPFICHAINVENTARIO, -- 14
         AOAUTORIZADO, -- 15
         AOPROCESSADO, -- 16
         AODIGITADO, -- 17
         CDDIGITADOR, -- 18
         AOAPROVADO -- 19
         )
      VALUES
        (1805, -- 1
         SQ_FIC_INV.NEXTVAL, -- 2
         V_DADOS_COD_INT, -- 3
         'FARM', -- 4
         'UNICO', -- 5
         'UNICO', -- 6
         'NORMA', -- 7
         'NAO', -- 8
         V_DADOS_UNID_MEDI, -- 9
         TO_NUMBER(V_DADOS_QUANTID), -- 10
         TO_NUMBER(V_DADOS_QUANTID), -- 11
         1, -- 12
         'N', -- 13
         'SIS', -- 14
         'S', -- 15
         'N', -- 16
         'S', -- 17
         'rlima', -- 18
         'N'); -- 19*/

      -- Realizando commit a cada 1000 registros
      IF V_CONT = 1000 THEN
        V_CONT := 0;
        COMMIT;
      END IF;

      -- Incrementando o contador a cada registro inserido
      V_CONT := V_CONT + 1;

      -- Finalizando o processo quando os dados do arquivo txt terminarem --
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          COMMIT;
          EXIT;
        END;

    END;
  END LOOP;

  -- Fechando a conexão com o arquivo txt
  UTL_FILE.FCLOSE_ALL;

END PR_IMPORTA_INVENTARIO;

