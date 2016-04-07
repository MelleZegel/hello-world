--==============================================================================
-- ODI 12.1.3
-- Show mapping internal flow 
--==============================================================================
WITH mcn AS (
SELECT    m.NAME map, cpe.NAME to_cp, cps.NAME from_cp
     ,    cmp.NAME comp_name
     ,    cmp.type_name comp_type
     ,    t.table_name
     ,    cps.i_owner_map_comp i_cps, cpe.i_owner_map_comp i_cpe
     ,    cmp.i_map_ref, m.i_mapping, cmp.i_map_comp, cps.i_map_cp cps_i_map_cp, cpe.i_map_cp cpe_i_map_cp
     ,    ex.txt expression
     ,    aex.txt attr_expr
FROM      snp_mapping  m     
JOIN      snp_map_comp cmp     ON cmp.i_owner_mapping     = m.i_mapping
JOIN      snp_map_cp   cps     ON cps.i_owner_map_comp    = cmp.i_map_comp AND cps.direction = 'O'
LEFT JOIN snp_map_conn cnn     ON cnn.i_start_map_cp      = cps.i_map_cp     
LEFT JOIN snp_map_cp   cpe     ON cpe.i_map_cp            = cnn.i_end_map_cp
LEFT JOIN snp_map_ref  mr      ON mr.i_map_ref            = cmp.i_map_ref  
LEFT JOIN snp_table    t       ON t.i_table               = mr.i_ref_id 
LEFT JOIN snp_map_prop mp      ON mp.i_owner_map_comp     = cmp.i_map_comp AND mp.NAME IN ('JOIN_CONDITION', 'FILTER_CONDITION')
LEFT JOIN snp_map_expr ex      ON ex.i_owner_map_prop     = mp.i_map_prop
LEFT JOIN snp_map_attr ma      ON ma.i_owner_map_cp       = cps.i_map_cp  AND ma.NAME = 'RANG' 
LEFT JOIN snp_map_expr aex     ON aex.i_owner_map_attr    = ma.i_map_attr
  )
,    flw AS (
SELECT    mcn.map
     ,    rpad('.', (LEVEL-1)*2, '.') || comp_name AS flow
     ,    mcn.comp_type, table_name, expression, attr_expr
     ,    mcn.to_cp, mcn.from_cp
     ,    LEVEL steps, ltrim(sys_connect_by_path(comp_name, '<-'), '-') AS impact
--     ,    comp_name
--     ,    i_mapping, i_map_comp, cps_i_map_cp, cpe_i_map_cp
FROM      mcn START WITH i_cpe IS NULL CONNECT BY i_cpe = PRIOR i_cps
  )
SELECT    *
FROM      flw
WHERE     1=1
AND       map LIKE 'MAP_BLABLA%'
--AND       (impact LIKE '%<-ORG<-%' OR comp_name = 'ORG')
--AND       steps < 13
ORDER BY  map, impact
;

