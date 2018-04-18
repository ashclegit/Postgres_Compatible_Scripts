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

/*query 7*/

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

/*query 25*/
select * from (select
 i."i_item_id"
 ,i."i_item_desc"
 ,s."s_store_id"
 ,s."s_store_name"
 ,sum(ss."ss_net_profit") as store_sales_profit
 ,sum(sr."sr_net_loss") as store_returns_loss
 ,sum(cs."cs_net_profit") as catalog_sales_profit
 from
 "postgrestest"."store_sales" ss 
 ,"postgrestest"."store_returns" sr
 ,"postgrestest"."catalog_sales" cs
 ,"postgrestest"."date_dim" d1
 ,"postgrestest"."date_dim" d2
 ,"postgrestest"."date_dim" d3
 ,"postgrestest"."store" s
 ,"postgrestest"."item" i
 where
 d1."d_moy" = 4
 and d1."d_year" = 2000
 and d1."d_date_sk" = ss."ss_sold_date_sk"
 and i."i_item_sk" = ss."ss_item_sk"
 and s."s_store_sk" = ss."ss_store_sk"
 and ss."ss_customer_sk" = sr."sr_customer_sk"
 and ss."ss_item_sk" = sr."sr_item_sk"
 and ss."ss_ticket_number" = sr."sr_ticket_number"
 and sr."sr_returned_date_sk" = d2."d_date_sk"
 and d2."d_moy"               between 4 and  10
 and d2."d_year"              = 2000
 and sr."sr_customer_sk" = cs."cs_bill_customer_sk"
 and sr."sr_item_sk" = cs."cs_item_sk"
 and cs."cs_sold_date_sk" = d3."d_date_sk"
 and d3."d_moy"               between 4 and  10
 and d3."d_year"              = 2000
 group by
 i."i_item_id"
 ,i."i_item_desc"
 ,s."s_store_id"
 ,s."s_store_name"
 order by
 i."i_item_id"
 ,i."i_item_desc"
 ,s."s_store_id"
 ,s."s_store_name"
  ) as tbl;

/*query 26*/

select * from (select  i."i_item_id",
        avg(cs."cs_quantity") agg1,
        avg(cs."cs_list_price") agg2,
        avg(cs."cs_coupon_amt") agg3,
        avg(cs."cs_sales_price") agg4
 from "postgrestest"."catalog_sales" cs, "postgrestest"."customer_demographics" cd, "postgrestest"."date_dim" d, "postgrestest"."item" i, "postgrestest"."promotion" p
 where cs."cs_sold_date_sk" = d."d_date_sk" and
       cs."cs_item_sk" = i."i_item_sk" and
       cs."cs_bill_cdemo_sk" = cd."cd_demo_sk" and
       cs."cs_promo_sk" = p."p_promo_sk" and
       cd."cd_gender" = 'F' and
       cd."cd_marital_status" = 'W' and
       cd."cd_education_status" = 'Primary' and
       (p."p_channel_email" = 'N' or p."p_channel_event" = 'N') and
       d."d_year" = 1998
 group by i."i_item_id"
 order by i."i_item_id"
  ) as tbl;

/*query 28*/
select * from (select  *
from (select avg(ss."ss_list_price") B1_LP
            ,count(ss."ss_list_price") B1_CNT
            ,count(distinct ss."ss_list_price") B1_CNTD
      from "postgrestest"."store_sales" ss
      where ss."ss_quantity" between 0 and 5
        and (ss."ss_list_price" between 11 and 11+10
             or ss."ss_coupon_amt" between 460 and 460+1000
             or ss."ss_wholesale_cost" between 14 and 14+20)) B1,
     (select avg(ss."ss_list_price") B2_LP
            ,count(ss."ss_list_price") B2_CNT
            ,count(distinct ss."ss_list_price") B2_CNTD
      from "postgrestest"."store_sales" ss
      where ss."ss_quantity" between 6 and 10
        and (ss."ss_list_price" between 91 and 91+10
          or ss."ss_coupon_amt" between 1430 and 1430+1000
          or ss."ss_wholesale_cost" between 32 and 32+20)) B2,
     (select avg(ss."ss_list_price") B3_LP
            ,count(ss."ss_list_price") B3_CNT
            ,count(distinct ss."ss_list_price") B3_CNTD
      from "postgrestest"."store_sales" ss
      where ss."ss_quantity" between 11 and 15
        and (ss."ss_list_price" between 66 and 66+10
          or ss."ss_coupon_amt" between 920 and 920+1000
          or ss."ss_wholesale_cost" between 4 and 4+20)) B3,
     (select avg(ss."ss_list_price") B4_LP
            ,count(ss."ss_list_price") B4_CNT
            ,count(distinct ss."ss_list_price") B4_CNTD
      from "postgrestest"."store_sales" ss 
      where ss."ss_quantity" between 16 and 20
        and (ss."ss_list_price" between 142 and 142+10
          or ss."ss_coupon_amt" between 3054 and 3054+1000
          or ss."ss_wholesale_cost" between 80 and 80+20)) B4,
     (select avg(ss."ss_list_price") B5_LP
            ,count(ss."ss_list_price") B5_CNT
            ,count(distinct ss."ss_list_price") B5_CNTD
      from "postgrestest"."store_sales" ss
      where ss."ss_quantity" between 21 and 25
        and (ss."ss_list_price" between 135 and 135+10
          or ss."ss_coupon_amt" between 14180 and 14180+1000
          or ss."ss_wholesale_cost" between 38 and 38+20)) B5,
     (select avg(ss."ss_list_price") B6_LP
            ,count(ss."ss_list_price") B6_CNT
            ,count(distinct ss."ss_list_price") B6_CNTD
      from "postgrestest"."store_sales" ss
      where ss."ss_quantity" between 26 and 30
        and (ss."ss_list_price" between 28 and 28+10
          or ss."ss_coupon_amt" between 2513 and 2513+1000
          or ss."ss_wholesale_cost" between 42 and 42+20)) B6
 ) as tbl;

/*query 29 */

select * from (select
     i."i_item_id"
    ,i."i_item_desc"
    ,s."s_store_id"
    ,s."s_store_name"
    ,sum(ss."ss_quantity")        as store_sales_quantity
    ,sum(sr."sr_return_quantity") as store_returns_quantity
    ,sum(cs."cs_quantity")        as catalog_sales_quantity
 from
    "postgrestest"."store_sales" ss
   ,"postgrestest"."store_returns" sr
   ,"postgrestest"."catalog_sales" cs
   ,"postgrestest"."date_dim"             d1
   ,"postgrestest"."date_dim"             d2
   ,"postgrestest"."date_dim"             d3
   ,"postgrestest"."store" s
   ,"postgrestest"."item" i
 where
     d1."d_moy"               = 4
 and d1."d_year"              = 1999
 and d1."d_date_sk"           = ss."ss_sold_date_sk"
 and i."i_item_sk"              = ss."ss_item_sk"
 and s."s_store_sk"             = ss."ss_store_sk"
 and ss."ss_customer_sk"         = sr."sr_customer_sk"
 and ss."ss_item_sk"             = sr."sr_item_sk"
 and ss."ss_ticket_number"       = sr."sr_ticket_number"
 and sr."sr_returned_date_sk"    = d2."d_date_sk"
 and d2."d_moy"               between 4 and  4 + 3
 and d2."d_year"              = 1999
 and sr."sr_customer_sk"         = cs."cs_bill_customer_sk"
 and sr."sr_item_sk"             = cs."cs_item_sk"
 and cs."cs_sold_date_sk"        = d3."d_date_sk"
 and d3."d_year"              in (1999,1999+1,1999+2)
 group by
    i."i_item_id"
   ,i."i_item_desc"
   ,s."s_store_id"
   ,s."s_store_name"
 order by
    i."i_item_id"
   ,i."i_item_desc"
   ,s."s_store_id"
   ,s."s_store_name"
  ) as tbl;

/*query3*/

select * from (select  dt."d_year"
       ,i."i_brand_id" brand_id
       ,i."i_brand" brand
       ,sum(ss."ss_ext_sales_price") sum_agg
 from  "postgrestest"."date_dim" dt
      ,"postgrestest"."store_sales" ss
      ,"postgrestest"."item" i
 where dt."d_date_sk" = ss."ss_sold_date_sk"
   and ss."ss_item_sk" = i."i_item_sk"
   and i."i_manufact_id" = 436
   and dt."d_moy"=12
 group by dt."d_year"
      ,i."i_brand"
      ,i."i_brand_id"
 order by dt."d_year"
         ,sum_agg desc
         ,brand_id
  ) as tbl LIMIT 100;


/*query32*/

select * from (select  sum(cs."cs_ext_discount_amt")  as "excess discount amount"
from
   "postgrestest"."catalog_sales" cs
   ,"postgrestest"."item" i
   ,"postgrestest"."date_dim" d
where
i."i_manufact_id" = 269
and i."i_item_sk" = cs."cs_item_sk"
and d."d_date" between '1998-03-18' and
        (cast('1998-03-18' as date ) + INTERVAL '90' day)
and d."d_date_sk" = cs."cs_sold_date_sk"
and cs."cs_ext_discount_amt"
     > (
         select
            1.3 * avg(cs."cs_ext_discount_amt")
         from
            "postgrestest"."catalog_sales" cs
           ,"postgrestest"."date_dim" d
         where
              cs."cs_item_sk" = i."i_item_sk"
          and d."d_date" between '1998-03-18' and
                             (cast('1998-03-18' as date) + INTERVAL '90' day)
          and d."d_date_sk" = cs."cs_sold_date_sk"
      )
 ) as tbl limit 100;

/*query 35*/

select * from (select
  ca."ca_state",
  cd."cd_gender",
  cd."cd_marital_status",
  cd."cd_dep_count",
  count(*) cnt1,
  avg(cd."cd_dep_count"),
  max(cd."cd_dep_count"),
  sum(cd."cd_dep_count"),
  cd."cd_dep_employed_count",
  count(*) cnt2,
  avg(cd."cd_dep_employed_count"),
  max(cd."cd_dep_employed_count"),
  sum(cd."cd_dep_employed_count"),
  cd."cd_dep_college_count",
  count(*) cnt3,
  avg(cd."cd_dep_college_count"),
  max(cd."cd_dep_college_count"),
  sum(cd."cd_dep_college_count")
 from
  "postgrestest"."customer" c,
  "postgrestest"."customer_address" ca,
  "postgrestest"."customer_demographics" cd
 where
  c."c_current_addr_sk" = ca."ca_address_sk" and
  cd."cd_demo_sk" = c."c_current_cdemo_sk" and
  exists (select *
          from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d
          where c."c_customer_sk" = ss."ss_customer_sk" and
                ss."ss_sold_date_sk" = d."d_date_sk" and
                d."d_year" = 1999 and
                d."d_qoy" < 4) and
   (exists (select *
            from "postgrestest"."web_sales" ws,"postgrestest"."date_dim" d
            where c."c_customer_sk" = ws."ws_bill_customer_sk" and
                  ws."ws_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 1999 and
                  d."d_qoy" < 4) or
    exists (select *
            from "postgrestest"."catalog_sales" cs,"postgrestest"."date_dim" d
            where c."c_customer_sk" = cs."cs_ship_customer_sk" and
                  cs."cs_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 1999 and
                  d."d_qoy" < 4))
 group by ca."ca_state",
          cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_dep_count",
          cd."cd_dep_employed_count",
          cd."cd_dep_college_count"
 order by ca."ca_state",
          cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_dep_count",
          cd."cd_dep_employed_count",
          cd."cd_dep_college_count"
  ) as tbl;


/* query 36 */

select * from (select
    sum(ss."ss_net_profit")/sum(ss."ss_ext_sales_price") as gross_margin
   ,i."i_category"
   ,i."i_class"
   ,grouping(i."i_category")+grouping(i."i_class") as lochierarchy
   ,rank() over (
        partition by grouping(i."i_category")+grouping(i."i_class"),
        case when grouping(i."i_class") = 0 then i."i_category" end
        order by sum(ss."ss_net_profit")/sum(ss."ss_ext_sales_price") asc) as rank_within_parent
 from
    "postgrestest"."store_sales" ss
   ,"postgrestest"."date_dim"       d1
   ,"postgrestest"."item" i
   ,"postgrestest"."store" s
 where
    d1."d_year" = 2000
 and d1."d_date_sk" = ss."ss_sold_date_sk"
 and i."i_item_sk"  = ss."ss_item_sk"
 and s."s_store_sk"  = ss."ss_store_sk"
 and s."s_state" in ('TN','TN','TN','TN',
                 'TN','TN','TN','TN')
 group by rollup(i."i_category",i."i_class")) as tbl
 order by
   tbl.lochierarchy desc
  ,case when tbl.lochierarchy = 0 then tbl."i_category" end
  ,tbl.rank_within_parent;


/* query 37 */

select * from (select  i."i_item_id"
       ,i."i_item_desc"
       ,i."i_current_price"
 from "postgrestest"."item" i, "postgrestest"."inventory" inv, "postgrestest"."date_dim" d, "postgrestest"."catalog_sales" cs
 where i."i_current_price" between 22 and 22 + 30
 and inv."inv_item_sk" = i."i_item_sk"
 and d."d_date_sk"=inv."inv_date_sk"
 and d."d_date" between cast('2001-06-02' as date) and (cast('2001-06-02' as date) +  INTERVAL '60' day)
 and i."i_manufact_id" in (678,964,918,849)
 and inv."inv_quantity_on_hand" between 100 and 500
 and cs."cs_item_sk" = i."i_item_sk"
 group by i."i_item_id",i."i_item_desc",i."i_current_price"
 order by i."i_item_id"
  ) as tbl limit 100;


/* query 48 */

select sum (ss."ss_quantity")
 from "postgrestest"."store_sales" ss, "postgrestest"."store" s, "postgrestest"."customer_demographics" cd, "postgrestest"."customer_address" ca, "postgrestest"."date_dim" d
 where s."s_store_sk" = ss."ss_store_sk"
 and  ss."ss_sold_date_sk" = d."d_date_sk" and d."d_year" = 1998
 and
 (
  (
   cd."cd_demo_sk" = ss."ss_cdemo_sk"
   and
   cd."cd_marital_status" = 'M'
   and
   cd."cd_education_status" = '4 yr Degree'
   and
   ss."ss_sales_price" between 100.00 and 150.00
   )
 or
  (
  cd."cd_demo_sk" = ss."ss_cdemo_sk"
   and
   cd."cd_marital_status" = 'D'
   and
   cd."cd_education_status" = 'Primary'
   and
   ss."ss_sales_price" between 50.00 and 100.00
  )
 or
 (
  cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and
   cd."cd_marital_status" = 'U'
   and
   cd."cd_education_status" = 'Advanced Degree'
   and
   ss."ss_sales_price" between 150.00 and 200.00
 )
 )
 and
 (
  (
  ss."ss_addr_sk" = ca."ca_address_sk"
  and
  ca."ca_country" = 'United States'
  and
  ca."ca_state" in ('KY', 'GA', 'NM')
  and ss."ss_net_profit" between 0 and 2000
  )
 or
  (ss."ss_addr_sk" = ca."ca_address_sk"
  and
  ca."ca_country" = 'United States'
  and
  ca."ca_state" in ('MT', 'OR', 'IN')
  and ss."ss_net_profit" between 150 and 3000
  )
 or
  (ss."ss_addr_sk" = ca."ca_address_sk"
  and
  ca."ca_country" = 'United States'
  and
  ca."ca_state" in ('WI', 'MO', 'WV')
  and ss."ss_net_profit" between 50 and 25000
  )
 )
;


/*query 43 */

select * from (select  s."s_store_name", s."s_store_id",
        sum(case when (d."d."d_day_name""='Sunday') then ss."ss_sales_price" else null end) sun_sales,
        sum(case when (d."d_day_name"='Monday') then ss."ss_sales_price" else null end) mon_sales,
        sum(case when (d."d_day_name"='Tuesday') then ss."ss_sales_price" else  null end) tue_sales,
        sum(case when (d."d_day_name"='Wednesday') then ss."ss_sales_price" else null end) wed_sales,
        sum(case when (d."d_day_name"='Thursday') then ss."ss_sales_price" else null end) thu_sales,
        sum(case when (d."d_day_name"='Friday') then ss."ss_sales_price" else null end) fri_sales,
        sum(case when (d."d_day_name"='Saturday') then ss."ss_sales_price" else null end) sat_sales
 from "postgrestest"."date_dim", "postgrestest"."store_sales", "postgrestest"."store"
 where s."d_date_sk" = ss."ss_sold_date_sk" and
       s."s_store_sk" = ss."ss_store_sk" and
       s."s_gmt_offset" = -5 and
       d."d_year" = 1998
 group by s."s_store_name", s."s_store_id"
 order by s."s_store_name", s."s_store_id",sun_sales,mon_sales,tue_sales,wed_sales,thu_sales,fri_sales,sat_sales
  ) as tbl;

/*query 40 */
select * from (select
   w."w_state"
  ,i."i_item_id"
  ,sum(case when (cast(d."d_date" as timestamp(0)) < cast ('1998-04-08' as timestamp(0)))
                then cs."cs_sales_price" - coalesce(cr."cr_refunded_cash",0) else 0 end) as sales_before
  ,sum(case when (cast(d."d_date" as timestamp(0)) >= cast ('1998-04-08' as timestamp(0)))
                then cs."cs_sales_price" - coalesce(cr."cr_refunded_cash",0) else 0 end) as sales_after
 from
   "postgrestest"."catalog_sales" cs left outer join "postgrestest"."catalog_returns" cr on
       (cs."cs_order_number" = cr."cr_order_number"
        and cs."cs_item_sk" = cr."cr_item_sk")
  ,"postgrestest"."warehouse" w
  ,"postgrestest"."item" i
  ,"postgrestest"."date_dim" d
 where
     i."i_current_price" between 0.99 and 1.49
 and i."i_item_sk"          = cs."cs_item_sk"
 and cs."cs_warehouse_sk"    = w."w_warehouse_sk"
 and cs."cs_sold_date_sk"    = d."d_date_sk"
 and d."d_date" between (cast ('1998-04-08' as date) -  INTERVAL '30' day)
                and (cast ('1998-04-08' as date) +  INTERVAL '30' day)
 group by
    w."w_state",i."i_item_id"
 order by w."w_state",i."i_item_id"
 ) as tbl limit 100;





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


/* query 95 */
with ws_wh as
(select ws1."ws_order_number",ws1."ws_warehouse_sk" wh1,ws2."ws_warehouse_sk" wh2
from "postgrestest"."web_sales" ws1,"postgrestest"."web_sales" ws2
where ws1."ws_order_number" = ws2."ws_order_number"
  and ws1."ws_warehouse_sk" <> ws2."ws_warehouse_sk")
select
  count(distinct ws."ws_order_number") as "order count"
 ,sum(ws."ws_ext_ship_cost") as "total shipping cost"
 ,sum(ws."ws_net_profit") as "total net profit"
from
  "postgrestest"."web_sales" ws
 ,"postgrestest"."date_dim" d
 ,"postgrestest"."customer_address" ca
 ,"postgrestest"."web_site" web
where
   d."d_date" between '1999-5-01' and
          (cast('1999-5-01' as date) + INTERVAL '60' day)
and ws."ws_ship_date_sk" = d."d_date_sk"
and ws."ws_ship_addr_sk" = ca."ca_address_sk"
and ca."ca_state" = 'MT'
and ws."ws_web_site_sk" = web."web_site_sk"
and web."web_company_name" = 'pri'
and ws."ws_order_number" in (select ws."ws_order_number"
                           from ws_wh)
and ws."ws_order_number" in (select wr."wr_order_number"
                           from "postgrestest"."web_returns" wr,ws_wh 
                           where wr."wr_order_number" = ws_wh."ws_order_number")
order by count(distinct ws."ws_order_number")
limit 10;

/*query 98 */

select i."i_item_id"
      ,i."i_item_desc"
      ,i."i_category"
      ,i."i_class"
      ,i."i_current_price"
      ,sum(ss."ss_ext_sales_price") as "itemrevenue"
      ,sum(ss."ss_ext_sales_price")*100/sum(sum(ss."ss_ext_sales_price")) over
          (partition by i."i_class") as revenueratio
from
        "postgrestest"."store_sales" ss
        ,"postgrestest"."item" i
        ,"postgrestest"."date_dim" d
where
        ss."ss_item_sk" = i."i_item_sk"
        and i."i_category" in ('Jewelry', 'Sports', 'Books')
        and ss."ss_sold_date_sk" = d."d_date_sk"
        and d."d_date" between cast('2001-01-12' as date)
                                and (cast('2001-01-12' as date) + INTERVAL '30' day )
group by
        i."i_item_id"
        ,i."i_item_desc"
        ,i."i_category"
        ,i."i_class"
        ,i."i_current_price"
order by
        i."i_category"
        ,i."i_class"
        ,i."i_item_id"
        ,i."i_item_desc"
        ,revenueratio;


select i."i_item_id"
      ,i."i_item_desc"
      ,i."i_category"
      ,i."i_class"
      ,i."i_current_price"
      ,sum(ss."ss_ext_sales_price") as "itemrevenue"
from
        "postgrestest"."store_sales" ss
        ,"postgrestest"."item" i
        ,"postgrestest"."date_dim" d
where
        ss."ss_item_sk" = i."i_item_sk"
        and i."i_category" in ('Jewelry', 'Sports', 'Books')
        and ss."ss_sold_date_sk" = d."d_date_sk"
        and d."d_date" between cast('2001-01-12' as date)
                                and (cast('2001-01-12' as date) + INTERVAL '30' day )
group by
        i."i_item_id"
        ,i."i_item_desc"
        ,i."i_category"
        ,i."i_class"
        ,i."i_current_price"
order by
        i."i_category"
        ,i."i_class"
        ,i."i_item_id"
        ,i."i_item_desc";


/*query 78*/

with ws as
 (select d."d_year" as ws_sold_year, ws."ws_item_sk",
   ws."ws_bill_customer_sk" as ws_customer_sk,
   sum(ws."ws_quantity") ws_qty,
   sum(ws."ws_wholesale_cost") ws_wc,
   sum(ws."ws_sales_price") ws_sp
  from "postgrestest"."web_sales" ws
  left join "postgrestest"."web_returns" wr on wr."wr_order_number"=ws."ws_order_number" and ws."ws_item_sk"=wr."wr_item_sk"
  join "postgrestest"."date_dim" d on ws."ws_sold_date_sk" = d."d_date_sk"
  where wr."wr_order_number" is null
  group by d."d_year", ws."ws_item_sk", ws."ws_bill_customer_sk"
  ),
cs as
 (select d."d_year" AS cs_sold_year, cs."cs_item_sk",
   cs."cs_bill_customer_sk" as cs_customer_sk,
   sum(cs."cs_quantity") cs_qty,
   sum(cs."cs_wholesale_cost") cs_wc,
   sum(cs."cs_sales_price") cs_sp
  from "postgrestest"."catalog_sales" cs
  left join "postgrestest"."catalog_returns" cr on cr."cr_order_number"=cs."cs_order_number" and cs."cs_item_sk"=cr."cr_item_sk"
  join "postgrestest"."date_dim" d on cs."cs_sold_date_sk" = d."d_date_sk"
  where cr."cr_order_number" is null
  group by d."d_year", cs."cs_item_sk", cs."cs_bill_customer_sk"
  ),
ss as
 (select d."d_year" AS ss_sold_year, ss."ss_item_sk",
   ss."ss_customer_sk",
   sum(ss."ss_quantity") ss_qty,
   sum(ss."ss_wholesale_cost") ss_wc,
   sum(ss."ss_sales_price") ss_sp
  from "postgrestest"."store_sales" ss
  left join "postgrestest"."store_returns" sr on sr."sr_ticket_number"=ss."ss_ticket_number" and ss."ss_item_sk"=sr."sr_item_sk"
  join "postgrestest"."date_dim" d on ss."ss_sold_date_sk" = d."d_date_sk"
  where sr."sr_ticket_number" is null
  group by d."d_year", ss."ss_item_sk", ss."ss_customer_sk"
  )
select * from ( select
ss_sold_year, ss."ss_item_sk", ss."ss_customer_sk",
round(ss.ss_qty/(coalesce(ws_qty,0)+coalesce(cs_qty,0)),2) ratio,
ss_qty store_qty, ss_wc store_wholesale_cost, ss_sp store_sales_price,
coalesce(ws_qty,0)+coalesce(cs_qty,0) other_chan_qty,
coalesce(ws_wc,0)+coalesce(cs_wc,0) other_chan_wholesale_cost,
coalesce(ws_sp,0)+coalesce(cs_sp,0) other_chan_sales_price
from ss
left join ws on (ws_sold_year=ss_sold_year and ws."ws_item_sk"=ss."ss_item_sk" and ws_customer_sk=ss."ss_customer_sk")
left join cs on (cs_sold_year=ss_sold_year and cs."cs_item_sk"=ss."ss_item_sk" and cs_customer_sk=ss."ss_customer_sk")
where (coalesce(ws_qty,0)>0 or coalesce(cs_qty, 0)>0) and ss_sold_year=2000
order by
 ss_sold_year, ss."ss_item_sk", ss."ss_customer_sk",
 ss_qty desc, ss_wc desc, ss_sp desc,
 other_chan_qty,
 other_chan_wholesale_cost,
 other_chan_sales_price,
 ratio
) tbl limit 100;

 /*query 46*/

 select * from (select  c."c_last_name"
       ,c."c_first_name"
       ,current_addr."ca_city"
       ,bought_city
       ,dn."ss_ticket_number"
       ,amt,profit
 from
   (select ss."ss_ticket_number"
          ,ss."ss_customer_sk"
          ,ca."ca_city" bought_city
          ,sum(ss."ss_coupon_amt") amt
          ,sum(ss."ss_net_profit") profit
    from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d,"postgrestest"."store" s,"postgrestest"."household_demographics" hd,"postgrestest"."customer_address" ca
    where ss."ss_sold_date_sk" = d."d_date_sk"
    and ss."ss_store_sk" = s."s_store_sk"
    and ss."ss_hdemo_sk" = hd."hd_demo_sk"
    and ss."ss_addr_sk" = ca."ca_address_sk"
    and (hd."hd_dep_count" = 5 or
         hd."hd_vehicle_count"= 3)
    and d."d_dow" in (6,0)
    and d."d_year" in (1999,1999+1,1999+2)
    and s."s_city" in ('Midway','Fairview','Fairview','Midway','Fairview')
    group by ss."ss_ticket_number",ss."ss_customer_sk",ss."ss_addr_sk",ca."ca_city") dn,"postgrestest"."customer" c,"postgrestest"."customer_address" current_addr
    where dn."ss_customer_sk" = c."c_customer_sk"
      and c."c_current_addr_sk" = current_addr."ca_address_sk"
      and current_addr."ca_city" <> bought_city
  order by c."c_last_name"
          ,c."c_first_name"
          ,current_addr."ca_city"
          ,bought_city
          ,dn."ss_ticket_number"
   ) as tbl;


/*query 47*/ /*taking more time */
with v1 as(
 select i."i_category", i."i_brand",
        s."s_store_name", s."s_company_name",
        d."d_year", d."d_moy",
        sum(ss."ss_sales_price") sum_sales,
        avg(sum(ss."ss_sales_price")) over
          (partition by i."i_category", i."i_brand",
                     s."s_store_name", s."s_company_name", d."d_year")
          avg_monthly_sales,
        rank() over
          (partition by i."i_category", i."i_brand",
                     s."s_store_name", s."s_company_name"
           order by d."d_year", d."d_moy") rn
 from "postgrestest"."item" i , "postgrestest"."store_sales" ss, "postgrestest"."date_dim" d, "postgrestest"."store" s
 where ss."ss_item_sk" = i."i_item_sk" and
       ss."ss_sold_date_sk" = d."d_date_sk" and
       ss."ss_store_sk" = s."s_store_sk" and
       (
         d."d_year" = 2000 or
         ( d."d_year" = 2000-1 and d."d_moy" =12) or
         ( d."d_year" = 2000+1 and d."d_moy" =1)
       )
 group by i."i_category", i."i_brand",
          s."s_store_name", s."s_company_name",
          d."d_year", d."d_moy"),
 v2 as(
 select v1."i_category"
        ,v1."d_year", v1."d_moy"
        ,v1.avg_monthly_sales
        ,v1.sum_sales, v1_lag.sum_sales psum, v1_lead.sum_sales nsum
 from v1, v1 v1_lag, v1 v1_lead
 where v1."i_category" = v1_lag."i_category" and
       v1."i_category" = v1_lead."i_category" and
       v1."i_brand" = v1_lag."i_brand" and
       v1."i_brand" = v1_lead."i_brand" and
       v1."s_store_name" = v1_lag."s_store_name" and
       v1."s_store_name" = v1_lead."s_store_name" and
       v1."s_company_name" = v1_lag."s_company_name" and
       v1."s_company_name" = v1_lead."s_company_name" and
       v1.rn = v1_lag.rn + 1 and
       v1.rn = v1_lead.rn - 1)
 select * from ( select  *
 from v2
 where  v2."d_year" = 2000 and
        v2.avg_monthly_sales > 0 and
        case when v2.avg_monthly_sales > 0 then abs(v2.sum_sales - v2.avg_monthly_sales) / v2.avg_monthly_sales else null end > 0.1
 order by v2.sum_sales - v2.avg_monthly_sales, 3
  ) as tbl;

 /*query 48*/


with v1 as(
 select i."i_category", i."i_brand",
        s."s_store_name", s."s_company_name",
        d."d_year", d."d_moy",
        sum(ss."ss_sales_price") sum_sales,
        avg(sum(ss."ss_sales_price")) over
          (partition by i."i_category", i."i_brand",
                     s."s_store_name", s."s_company_name", d."d_year")
          avg_monthly_sales,
        rank() over
          (partition by i."i_category", i."i_brand",
                     s."s_store_name", s."s_company_name"
           order by d."d_year", d."d_moy") rn
 from "postgrestest"."item" i , "postgrestest"."store_sales" ss, "postgrestest"."date_dim" d, "postgrestest"."store" s
 where ss."ss_item_sk" = i."i_item_sk" and
       ss."ss_sold_date_sk" = d."d_date_sk" and
       ss."ss_store_sk" = s."s_store_sk" and
       (
         d."d_year" = 2000 or
         ( d."d_year" = 2000-1 and d."d_moy" =12) or
         ( d."d_year" = 2000+1 and d."d_moy" =1)
       )
 group by i."i_category", i."i_brand",
          s."s_store_name", s."s_company_name",
          d."d_year", d."d_moy"),
 v2 as(
 select v1."i_category"
        ,v1."d_year", v1."d_moy"
        ,v1.avg_monthly_sales
        ,v1.sum_sales, v1_lag.sum_sales psum, v1_lead.sum_sales nsum
 from v1, v1 v1_lag, v1 v1_lead
 where v1."i_category" = v1_lag."i_category" and
       v1."i_category" = v1_lead."i_category" and
       v1."i_brand" = v1_lag."i_brand" and
       v1."i_brand" = v1_lead."i_brand" and
       v1."s_store_name" = v1_lag."s_store_name" and
       v1."s_store_name" = v1_lead."s_store_name" and
       v1."s_company_name" = v1_lag."s_company_name" and
       v1."s_company_name" = v1_lead."s_company_name" and
       v1.rn = v1_lag.rn + 1 and
       v1.rn = v1_lead.rn - 1)
 select * from ( select  *
 from v2
 where  v2."d_year" = 2000 and
        v2.avg_monthly_sales > 0 and
        case when v2.avg_monthly_sales > 0 then abs(v2.sum_sales - v2.avg_monthly_sales) / v2.avg_monthly_sales else null end > 0.1
 order by v2.sum_sales - v2.avg_monthly_sales, 3
  ) as tbl;



/*query 33*/ /* not working */

with ss as (
 select
          i."i_manufact_id",sum(ss."ss_ext_sales_price") total_sales
 from
        "postgrestest"."store_sales" ss,
        "postgrestest"."date_dim" d,
         "postgrestest"."customer_address" ca,
         "postgrestest"."item" i
 where
         i."i_manufact_id" in (select
  i."i_manufact_id"
from
 "postgrestest"."item" i
where i."i_category" in ('Books'))
 and     ss."ss_item_sk"              = i."i_item_sk"
 and     ss."ss_sold_date_sk"         = d."d_date_sk"
 and     d."d_year"                  = 1999
 and     d."d_moy"                   = 3
 and     ss."ss_addr_sk"              = ca."ca_address_sk"
 and     ca."ca_gmt_offset"           = -5
 group by i."i_manufact_id"),
 cs as (
 select
          i."i_manufact_id",sum(cs."cs_ext_sales_price") total_sales
 from
        "postgrestest"."catalog_sales" cs,
        "postgrestest"."date_dim" d,
         "postgrestest"."customer_address" ca,
         "postgrestest"."item" i
 where
         i."i_manufact_id"               in (select
  i."i_manufact_id"
from
 "postgrestest"."item"
where i."i_category" in ('Books'))
 and     cs."cs_item_sk"              = i."i_item_sk"
 and     cs."cs_sold_date_sk"         = d."d_date_sk"
 and     d."d_year"                  = 1999
 and     d."d_moy"                   = 3
 and     cs."cs_bill_addr_sk"         = ca."ca_address_sk"
 and     ca."ca_gmt_offset"           = -5
 group by i."i_manufact_id"),
 ws as (
 select
          i."i_manufact_id",sum(ws."ws_ext_sales_price") total_sales
 from
        "postgrestest"."web_sales" ws,
        "postgrestest"."date_dim" d,
         "postgrestest"."customer_address" ca,
         "postgrestest"."item" i
 where
         i."i_manufact_id"               in (select
  i."i_manufact_id"
from
 "postgrestest"."item" i
where i."i_category" in ('Books'))
 and     ws."ws_item_sk"              = i."i_item_sk"
 and     ws."ws_sold_date_sk"         = d."d_date_sk"
 and     d."d_year"                  = 1999
 and     d."d_moy"                   = 3
  and     ws."ws_bill_addr_sk"         = ca."ca_address_sk"
 and     ca."ca_gmt_offset"           = -5
 group by i."i_manufact_id")
 select * from ( select  i_manufact_id ,sum(total_sales) total_sales
 from  (select * from ss
        union all
        select * from cs
        union all
        select * from ws) tmp1
 group by i_manufact_id
 order by total_sales
 ) as tbl;


/*query 45*/
select * from (select  ca."ca_zip", ca."ca_county", sum(ws."ws_sales_price")
 from "postgrestest"."web_sales" ws, "postgrestest"."customer" c, "postgrestest"."customer_address" ca, "postgrestest"."date_dim" d, "postgrestest"."item" i
 where ws."ws_bill_customer_sk" = c."c_customer_sk"
        and c."c_current_addr_sk" = ca."ca_address_sk"
        and ws."ws_item_sk" = i."i_item_sk"
        and ( substr(ca."ca_zip",1,5) in ('85669', '86197','88274','83405','86475', '85392', '85460', '80348', '81792')
              or
              i_item_id in (select i."i_item_id"
                             from "postgrestest"."item"
                             where i."i_item_sk" in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
                             )
            )
        and ws."ws_sold_date_sk" = d."d_date_sk"
        and d."d_qoy" = 2 and d."d_year" = 2000
 group by ca."ca_zip", ca."ca_county"
 order by ca."ca_zip", ca."ca_county"
  ) as tbl;



