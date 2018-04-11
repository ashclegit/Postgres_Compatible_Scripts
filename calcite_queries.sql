/*query 19*/
select * from (select  i."i_brand_id" brand_id, i."i_brand" brand, i."i_manufact_id", i."i_manufact",
        sum(ss."ss_ext_sales_price") ext_price
 from "postgrestest"."date_dim" d, "postgrestest"."store_sales" ss, 
 "postgrestest"."item" i,
 "postgrestest"."customer" c,
 "postgrestest"."customer_address" ca,
 "postgrestest"."store" s
 where d."d_date_sk" = ss."ss_sold_date_sk"
   and ss."ss_item_sk" = i."i_item_sk"
   and i."i_manager_id"=7
   and d."d_moy"=11
   and d."d_year"=1999
   and ss."ss_customer_sk" = c."c_customer_sk"
   and c."c_current_addr_sk" = ca."ca_address_sk"
   and substring(ca."ca_zip",1,5) <> substring(s."s_zip",1,5)
   and ss."ss_store_sk" = s."s_store_sk"
 group by i."i_brand"
      ,i."i_brand_id"
      ,i."i_manufact_id"
      ,i."i_manufact"
 order by ext_price desc
         ,i."i_brand"
         ,i."i_brand_id"
         ,i."i_manufact_id"
         ,i."i_manufact"
 ) as tbl limit 10;

/*query 15*/
select * from (select  c."ca_zip"
       ,sum(a."cs_sales_price") 
 from "postgrestest"."catalog_sales" a
     ,"postgrestest"."customer" b
     ,"postgrestest"."customer_address" c
     ,"postgrestest"."date_dim" d
 where a."cs_bill_customer_sk" = b."c_customer_sk"
        and b."c_current_addr_sk" = c."ca_address_sk"
        and ( substring(c."ca_zip",1,5) in ('85669', '86197','88274','83405','86475',
                                   '85392', '85460', '80348', '81792')
              or c."ca_state" in ('CA','WA','GA')
              or a."cs_sales_price" > 500)
        and a."cs_sold_date_sk" = d."d_date_sk"
        and d."d_qoy" = 2 and d."d_year" = 2000
 group by c."ca_zip"
 order by c."ca_zip"
  ) as tbl;

/*query22*/

select * from (select  i."i_product_name"
             ,i."i_brand"
             ,i."i_class"
             ,i."i_category"
             ,avg(inv."inv_quantity_on_hand") qoh
       from "postgrestest"."inventory" inv
           ,"postgrestest"."date_dim" d
           ,"postgrestest"."item" i
       where inv."inv_date_sk"=d."d_date_sk"
              and inv."inv_item_sk"=i."i_item_sk"
              and d."d_month_seq" between 1212 and 1212 + 11
       group by rollup(i."i_product_name"
                       ,i."i_brand"
                       ,i."i_class"
                       ,i."i_category")
order by qoh, i."i_product_name", i."i_brand", i."i_class", i."i_category"
 ) as tbl;

/*query7*/

select * from (select  i."i_item_id",
        avg(ss."ss_quantity") agg1,
        avg(ss."ss_list_price") agg2,
        avg(ss."ss_coupon_amt") agg3,
        avg(ss."ss_sales_price") agg4
 from "postgrestest"."store_sales" ss, "postgrestest"."customer_demographics" cd, 
 "postgrestest"."date_dim" d, "postgrestest"."item" i, "postgrestest"."promotion" p
 where ss."ss_sold_date_sk" = d."d_date_sk" and
       ss."ss_item_sk" = i."i_item_sk" and
       ss."ss_cdemo_sk" = cd."cd_demo_sk" and
       ss."ss_promo_sk" = p."p_promo_sk" and
       cd."cd_gender" = 'F' and
       cd."cd_marital_status" = 'W' and
       cd."cd_education_status" = 'Primary' and
       (p."p_channel_email" = 'N' or p."p_channel_event" = 'N') and
       d_year = 1998
 group by i."i_item_id"
 order by i."i_item_id"
  ) as tbl;