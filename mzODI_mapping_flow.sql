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
select * 
from   mcn

order by mapping, comp_name
