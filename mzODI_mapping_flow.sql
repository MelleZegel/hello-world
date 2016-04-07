--==============================================================================
-- ODI 12.1.3
-- Show mapping internal flow 
--==============================================================================
WITH mcn AS (
SELECT    m.NAME MAPPING, cpe.NAME to_cp, cps.NAME from_cp
     ,    comp.NAME comp_name
     ,    comp.type_name comp_type
     ,    t.table_name
     ,    cps.i_owner_map_comp i_cps, cpe.i_owner_map_comp i_cpe
     ,    comp.i_map_ref, m.i_mapping, comp.i_map_comp, cps.i_map_cp cps_i_map_cp, cpe.i_map_cp cpe_i_map_cp
     ,    ex.txt 
FROM      snp_mapping  m     
JOIN      snp_map_comp comp    ON m.i_mapping             = comp.i_owner_mapping
JOIN      snp_map_cp   cps     ON cps.i_owner_map_comp    = comp.i_map_comp AND cps.direction = 'O'
LEFT JOIN snp_map_conn conn    ON cps.i_map_cp            = conn.i_start_map_cp 
LEFT JOIN snp_map_cp   cpe     ON cpe.i_map_cp            = conn.i_end_map_cp
LEFT JOIN snp_map_ref  mr      ON comp.i_map_ref          = mr.i_map_ref
LEFT JOIN snp_table    t       ON mr.i_ref_id             = t.i_table
LEFT JOIN snp_map_prop mp      ON comp.i_map_comp         = mp.i_owner_map_comp AND mp.NAME IN ('JOIN_CONDITION', 'FILTER_CONDITION')
LEFT JOIN snp_map_expr ex      ON mp.i_map_prop           = ex.i_owner_map_prop
  )
,    flw AS (
SELECT    mcn.MAPPING
     ,    rpad('.', (LEVEL-1)*2, '.') || comp_name AS flow
     ,    mcn.comp_type, table_name, txt
     ,    mcn.to_cp, mcn.from_cp
     ,    LEVEL steps, ltrim(sys_connect_by_path(comp_name, '<-'), '-') AS impact
     ,    comp_name
     ,    i_mapping, i_map_comp, cps_i_map_cp, cpe_i_map_cp
FROM      mcn START WITH i_cpe IS NULL CONNECT BY i_cpe = PRIOR i_cps
  )
SELECT    *
FROM      flw
WHERE     1=1
--AND       MAPPING LIKE 'MAP_BLABLA%'
--AND       (impact LIKE '%<-ORG<-%' OR comp_name = 'ORG')
--AND       steps < 13
ORDER BY  MAPPING, impact
;

