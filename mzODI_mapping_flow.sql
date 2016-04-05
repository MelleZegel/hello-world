with mcn as (
select m.name mapping
     , comp.name comp_name, comp.type_name comp_type
     , t.table_name
     , cps.i_owner_map_comp i_cps, cpe.i_owner_map_comp i_cpe
--     , comp.i_map_ref, comp.i_owner_mapping
FROM      snp_map_cp   cps   
JOIN      snp_map_conn conn  ON cps.i_map_cp            = conn.i_start_map_cp 
JOIN      snp_map_cp   cpe   ON cpe.i_map_cp            = conn.i_end_map_cp
JOIN      snp_map_comp comp  ON cps.i_owner_map_comp    = comp.i_map_comp
JOIN      snp_mapping  m     on m.i_mapping             = comp.i_owner_mapping
LEFT JOIN snp_map_ref  mr    ON comp.i_map_ref          = mr.i_map_ref
LEFT JOIN snp_table    t     ON mr.i_ref_id             = t.i_table
  )
select level
     ,  RPAD('.', (level-1)*2, '.') || comp_name AS tree
     , LTRIM(SYS_CONNECT_BY_PATH(comp_name, '-'), '-') AS path
     , mcn.* 
from   mcn
connect by i_cps = prior i_cpe
order by mapping, 1, comp_name
--------------------------------------------------------------------------------

--SELECT id,
--       parent_id,
--       RPAD('.', (level-1)*2, '.') || id AS tree,
--       level,
--       CONNECT_BY_ROOT id AS root_id,
--       LTRIM(SYS_CONNECT_BY_PATH(id, '-'), '-') AS path,
--       CONNECT_BY_ISLEAF AS leaf
--FROM   tab1
--START WITH parent_id IS NULL
--CONNECT BY parent_id = PRIOR id
--ORDER SIBLINGS BY id;
