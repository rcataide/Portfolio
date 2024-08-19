SELECT EXTRACT(DAY FROM ac.dt_agenda) ||'/'|| EXTRACT(MONTH FROM ac.dt_agenda) AS MES
      ,EXTRACT(YEAR FROM ac.dt_agenda) AS ANO
  FROM AGENDA ac;
