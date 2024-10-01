/* Formatted on 30/10/2014 11:05:24 (QP5 v5.265.14096.38000) */
  SELECT DISTINCT NAME,
                  i.INSTANCE_NAME,
                  OPEN_MODE,
                  LOG_MODE
    FROM gv$database, gv$instance i
ORDER BY 2;