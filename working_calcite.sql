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
       d."d_year" = 1998
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


/*query 43 */
select * from (select  s."s_store_name", s."s_store_id",
        sum(case when (d."d_day_name"='Sunday') then ss."ss_sales_price" else null end) sun_sales,
        sum(case when (d."d_day_name"='Monday') then ss."ss_sales_price" else null end) mon_sales,
        sum(case when (d."d_day_name"='Tuesday') then ss."ss_sales_price" else  null end) tue_sales,
        sum(case when (d."d_day_name"='Wednesday') then ss."ss_sales_price" else null end) wed_sales,
        sum(case when (d."d_day_name"='Thursday') then ss."ss_sales_price" else null end) thu_sales,
        sum(case when (d."d_day_name"='Friday') then ss."ss_sales_price" else null end) fri_sales,
        sum(case when (d."d_day_name"='Saturday') then ss."ss_sales_price" else null end) sat_sales
 from "postgrestest"."date_dim" d, "postgrestest"."store_sales" ss, "postgrestest"."store" s
 where d."d_date_sk" = ss."ss_sold_date_sk" and
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


/*query 19*/ /* longer running time */
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

/*query45*/
select * from (select  ca."ca_zip", ca."ca_county", sum(ws."ws_sales_price")
 from "postgrestest"."web_sales" ws, "postgrestest"."customer" c, "postgrestest"."customer_address" ca, "postgrestest"."date_dim" d, "postgrestest"."item" i
 where ws."ws_bill_customer_sk" = c."c_customer_sk"
        and c."c_current_addr_sk" = ca."ca_address_sk"
        and ws."ws_item_sk" = i."i_item_sk"
        and ( substring(ca."ca_zip",1,5) in ('85669', '86197','88274','83405','86475', '85392', '85460', '80348', '81792')
              or
              i."i_item_id" in (select i."i_item_id"
                             from "postgrestest"."item"  i  --aliased  as "i"
                             where i."i_item_sk" in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
                             )
            )
        and ws."ws_sold_date_sk" = d."d_date_sk"
        and d."d_qoy" = 2 and d."d_year" = 2000
 group by ca."ca_zip", ca."ca_county"
 order by ca."ca_zip", ca."ca_county"
  ) as tbl;


 /*query 46*/ /* longer running time */
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


 /*query 48*/ /*longer running time*/
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



/*query 13*/  /* insufficient OS memory */
 select avg(ss."ss_quantity")
       ,avg(ss."ss_ext_sales_price")
       ,avg(ss."ss_ext_wholesale_cost")
       ,sum(ss."ss_ext_wholesale_cost")
 from "postgrestest"."store_sales" ss
     ,"postgrestest"."store" s
     ,"postgrestest"."customer_demographics" cd
     ,"postgrestest"."household_demographics" hd
     ,"postgrestest"."customer_address" ca
     ,"postgrestest"."date_dim" d
 where s."s_store_sk" = ss."ss_store_sk"
 and  ss."ss_sold_date_sk" = d."d_date_sk" and d."d_year" = 2001
 and((ss."ss_hdemo_sk"=hd."hd_demo_sk"
  and cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and cd."cd_marital_status" = 'D'
  and cd."cd_education_status" = '2 yr Degree'
  and ss."ss_sales_price" between 100.00 and 150.00
  and hd."hd_dep_count" = 3
     )or
     (ss."ss_hdemo_sk"=hd."hd_demo_sk"
  and cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and cd."cd_marital_status" = 'S'
  and cd."cd_education_status" = 'Secondary'
  and ss."ss_sales_price" between 50.00 and 100.00
  and hd."hd_dep_count" = 1
     ) or
     (ss."ss_hdemo_sk"=hd."hd_demo_sk"
  and cd."cd_demo_sk" = ss."ss_cdemo_sk"
  and cd."cd_marital_status" = 'W'
  and cd."cd_education_status" = 'Advanced Degree'
  and ss."ss_sales_price" between 150.00 and 200.00
  and hd."hd_dep_count" = 1
     ))
 and((ss."ss_addr_sk" = ca."ca_address_sk"
  and ca."ca_country" = 'United States'
  and ca."ca_state" in ('CO', 'IL', 'MN')
  and ss."ss_net_profit" between 100 and 200
     ) or
     (ss."ss_addr_sk" = ca."ca_address_sk"
  and ca."ca_country" = 'United States'
  and ca."ca_state" in ('OH', 'MT', 'NM')
  and ss."ss_net_profit" between 150 and 300  
     ) or
     (ss."ss_addr_sk" = ca."ca_address_sk"
  and ca."ca_country" = 'United States'
  and ca."ca_state" in ('TX', 'MO', 'MI')
  and ss."ss_net_profit" between 50 and 250
     ));

/*query 1*/
with customer_total_return as
(select sr."sr_customer_sk" as ctr_customer_sk
,sr."sr_store_sk" as ctr_store_sk
,sum(sr."sr_fee") as ctr_total_return
from "postgrestest"."store_returns" sr
,"postgrestest"."date_dim" d
where sr."sr_returned_date_sk" = d."d_date_sk"
and d."d_year" =2000
group by sr."sr_customer_sk"
,sr."sr_store_sk")
select * from ( select  c."c_customer_id"
from customer_total_return ctr1
,"postgrestest"."store" s
,"postgrestest"."customer" c
where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
from customer_total_return ctr2
where ctr1.ctr_store_sk = ctr2.ctr_store_sk)
and s."s_store_sk" = ctr1.ctr_store_sk
and s."s_state" = 'TN'
and ctr1.ctr_customer_sk = c."c_customer_sk"
order by c."c_customer_id"
 ) as tbl;


/*query 4*/ /*longer running time*/
with year_total as (
 select c."c_customer_id" customer_id
       ,c."c_first_name" customer_first_name
       ,c."c_last_name" customer_last_name
       ,c."c_preferred_cust_flag" customer_preferred_cust_flag
       ,c."c_birth_country" customer_birth_country
       ,c."c_login" customer_login
       ,c."c_email_address" customer_email_address
       ,d."d_year" dyear
       ,sum(((ss."ss_ext_list_price"-ss."ss_ext_wholesale_cost"-ss."ss_ext_discount_amt")+ss."ss_ext_sales_price")/2) year_total
       ,'s' sale_type
 from "postgrestest"."customer" c
     ,"postgrestest"."store_sales" ss
     ,"postgrestest"."date_dim" d
 where c."c_customer_sk" = ss."ss_customer_sk"
   and ss."ss_sold_date_sk" = d."d_date_sk"
 group by c."c_customer_id"
         ,c."c_first_name"
         ,c."c_last_name"
         ,c."c_preferred_cust_flag"
         ,c."c_birth_country"
         ,c."c_login"
         ,c."c_email_address"
         ,d."d_year"
 union all
 select c."c_customer_id" customer_id
       ,c."c_first_name" customer_first_name
       ,c."c_last_name" customer_last_name
       ,c."c_preferred_cust_flag" customer_preferred_cust_flag
       ,c."c_birth_country" customer_birth_country
       ,c."c_login" customer_login
       ,c."c_email_address" customer_email_address
       ,d."d_year" dyear
       ,sum((((cs."cs_ext_list_price"-cs."cs_ext_wholesale_cost"-cs."cs_ext_discount_amt")+cs."cs_ext_sales_price")/2) ) year_total
       ,'c' sale_type
 from "postgrestest"."customer" c
     ,"postgrestest"."catalog_sales" cs
     ,"postgrestest"."date_dim" d
 where c."c_customer_sk" = cs."cs_bill_customer_sk"
   and cs."cs_sold_date_sk" = d."d_date_sk"
 group by c."c_customer_id"
         ,c."c_first_name"
         ,c."c_last_name"
         ,c."c_preferred_cust_flag"
         ,c."c_birth_country"
         ,c."c_login"
         ,c."c_email_address"
         ,d."d_year"
union all
 select c."c_customer_id" customer_id
       ,c."c_first_name" customer_first_name
       ,c."c_last_name" customer_last_name
       ,c."c_preferred_cust_flag" customer_preferred_cust_flag
       ,c."c_birth_country" customer_birth_country
       ,c."c_login" customer_login
       ,c."c_email_address" customer_email_address
       ,d."d_year" dyear
       ,sum((((ws."ws_ext_list_price"-ws."ws_ext_wholesale_cost"-ws."ws_ext_discount_amt")+ws."ws_ext_sales_price")/2) ) year_total
       ,'w' sale_type
 from "postgrestest"."customer" c
     ,"postgrestest"."web_sales" ws
     ,"postgrestest"."date_dim" d
 where c."c_customer_sk" = ws."ws_bill_customer_sk"
   and ws."ws_sold_date_sk" = d."d_date_sk"
group by c."c_customer_id"
         ,c."c_first_name"
         ,c."c_last_name"
         ,c."c_preferred_cust_flag"
         ,c."c_birth_country"
         ,c."c_login"
         ,c."c_email_address"
         ,d."d_year"
         )
select * from (  select
                  t_s_secyear.customer_id
                 ,t_s_secyear.customer_first_name
                 ,t_s_secyear.customer_last_name
                 ,t_s_secyear.customer_email_address
 from year_total t_s_firstyear
     ,year_total t_s_secyear
     ,year_total t_c_firstyear
     ,year_total t_c_secyear
     ,year_total t_w_firstyear
     ,year_total t_w_secyear
 where t_s_secyear.customer_id = t_s_firstyear.customer_id
   and t_s_firstyear.customer_id = t_c_secyear.customer_id
   and t_s_firstyear.customer_id = t_c_firstyear.customer_id
   and t_s_firstyear.customer_id = t_w_firstyear.customer_id
   and t_s_firstyear.customer_id = t_w_secyear.customer_id
   and t_s_firstyear.sale_type = 's'
   and t_c_firstyear.sale_type = 'c'
   and t_w_firstyear.sale_type = 'w'
   and t_s_secyear.sale_type = 's'
   and t_c_secyear.sale_type = 'c'
   and t_w_secyear.sale_type = 'w'
   and t_s_firstyear.dyear =  2001
   and t_s_secyear.dyear = 2001+1
   and t_c_firstyear.dyear =  2001
   and t_c_secyear.dyear =  2001+1
   and t_w_firstyear.dyear = 2001
   and t_w_secyear.dyear = 2001+1
   and t_s_firstyear.year_total > 0
   and t_c_firstyear.year_total > 0
   and t_w_firstyear.year_total > 0
   and case when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total else null end
           > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else null end
   and case when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total else null end
           > case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else null end
 order by t_s_secyear.customer_id
         ,t_s_secyear.customer_first_name
         ,t_s_secyear.customer_last_name
         ,t_s_secyear.customer_email_address
 ) as tbl;


/*query 6*/
select * from (select  a."ca_state" state, count(*) cnt
 from "postgrestest"."customer_address" a
     ,"postgrestest"."customer" c
     ,"postgrestest"."store_sales" s
     ,"postgrestest"."date_dim" d
     ,"postgrestest"."item" i
 where       a."ca_address_sk" = c."c_current_addr_sk"
        and c."c_customer_sk" = s."ss_customer_sk"
        and s."ss_sold_date_sk" = d."d_date_sk"
        and s."ss_item_sk" = i."i_item_sk"
        and d."d_month_seq" =
             (select distinct (d."d_month_seq")
              from "postgrestest"."date_dim"
               where d."d_year" = 2000
                and d."d_moy" = 2 )
        and i."i_current_price" > 1.2 *
             (select avg(j."i_current_price")
             from "postgrestest"."item" j
             where j."i_category" = i."i_category")
 group by a."ca_state"
 having count(*) >= 10
 order by cnt, a."ca_state"
  ) as tbl;


/*query 6*/ /*gc limit exceeded*/
select * from (select  a."ca_state" state, count(*) cnt
 from "postgrestest"."customer_address" a
     ,"postgrestest"."customer" c
     ,"postgrestest"."store_sales" s
     ,"postgrestest"."date_dim" d
     ,"postgrestest"."item" i
 where       a."ca_address_sk" = c."c_current_addr_sk"
        and c."c_customer_sk" = s."ss_customer_sk"
        and s."ss_sold_date_sk" = d."d_date_sk"
        and s."ss_item_sk" = i."i_item_sk"
        and d."d_month_seq" =
             (select distinct (d."d_month_seq")
              from "postgrestest"."date_dim"
               where d."d_year" = 2000
                and d."d_moy" = 2 )
        and i."i_current_price" > 1.2 *
             (select avg(j."i_current_price")
             from "postgrestest"."item" j
             where j."i_category" = i."i_category")
 group by a."ca_state"
 having count(*) >= 10
 order by cnt, a."ca_state"
  ) as tbl;

/*query 8*/
select * from (select  s."s_store_name"
      ,sum(ss."ss_net_profit")
 from "postgrestest"."store_sales" ss
     ,"postgrestest"."date_dim" d
     ,"postgrestest"."store" s,
     (select ca_zip
     from (
      SELECT substring(ca."ca_zip",1,5) ca_zip
      FROM "postgrestest"."customer_address" ca
      WHERE substring(ca."ca_zip",1,5) IN (
                          '89436','30868','65085','22977','83927','77557',
                          '58429','40697','80614','10502','32779',
                          '91137','61265','98294','17921','18427',
                          '21203','59362','87291','84093','21505',
                          '17184','10866','67898','25797','28055',
                          '18377','80332','74535','21757','29742',
                          '90885','29898','17819','40811','25990',
                          '47513','89531','91068','10391','18846',
                          '99223','82637','41368','83658','86199',
                          '81625','26696','89338','88425','32200',
                          '81427','19053','77471','36610','99823',
                          '43276','41249','48584','83550','82276',
                          '18842','78890','14090','38123','40936',
                          '34425','19850','43286','80072','79188',
                          '54191','11395','50497','84861','90733',
                          '21068','57666','37119','25004','57835',
                          '70067','62878','95806','19303','18840',
                          '19124','29785','16737','16022','49613',
                          '89977','68310','60069','98360','48649',
                          '39050','41793','25002','27413','39736',
                          '47208','16515','94808','57648','15009',
                          '80015','42961','63982','21744','71853',
                          '81087','67468','34175','64008','20261',
                          '11201','51799','48043','45645','61163',
                          '48375','36447','57042','21218','41100',
                          '89951','22745','35851','83326','61125',
                          '78298','80752','49858','52940','96976',
                          '63792','11376','53582','18717','90226',
                          '50530','94203','99447','27670','96577',
                          '57856','56372','16165','23427','54561',
                          '28806','44439','22926','30123','61451',
                          '92397','56979','92309','70873','13355',
                          '21801','46346','37562','56458','28286',
                          '47306','99555','69399','26234','47546',
                          '49661','88601','35943','39936','25632',
                          '24611','44166','56648','30379','59785',
                          '11110','14329','93815','52226','71381',
                          '13842','25612','63294','14664','21077',
                          '82626','18799','60915','81020','56447',
                          '76619','11433','13414','42548','92713',
                          '70467','30884','47484','16072','38936',
                          '13036','88376','45539','35901','19506',
                          '65690','73957','71850','49231','14276',
                          '20005','18384','76615','11635','38177',
                          '55607','41369','95447','58581','58149',
                          '91946','33790','76232','75692','95464',
                          '22246','51061','56692','53121','77209',
                          '15482','10688','14868','45907','73520',
                          '72666','25734','17959','24677','66446',
                          '94627','53535','15560','41967','69297',
                          '11929','59403','33283','52232','57350',
                          '43933','40921','36635','10827','71286',
                          '19736','80619','25251','95042','15526',
                          '36496','55854','49124','81980','35375',
                          '49157','63512','28944','14946','36503',
                          '54010','18767','23969','43905','66979',
                          '33113','21286','58471','59080','13395',
                          '79144','70373','67031','38360','26705',
                          '50906','52406','26066','73146','15884',
                          '31897','30045','61068','45550','92454',
                          '13376','14354','19770','22928','97790',
                          '50723','46081','30202','14410','20223',
                          '88500','67298','13261','14172','81410',
                          '93578','83583','46047','94167','82564',
                          '21156','15799','86709','37931','74703',
                          '83103','23054','70470','72008','49247',
                          '91911','69998','20961','70070','63197',
                          '54853','88191','91830','49521','19454',
                          '81450','89091','62378','25683','61869',
                          '51744','36580','85778','36871','48121',
                          '28810','83712','45486','67393','26935',
                          '42393','20132','55349','86057','21309',
                          '80218','10094','11357','48819','39734',
                          '40758','30432','21204','29467','30214',
                          '61024','55307','74621','11622','68908',
                          '33032','52868','99194','99900','84936',
                          '69036','99149','45013','32895','59004',
                          '32322','14933','32936','33562','72550',
                          '27385','58049','58200','16808','21360',
                          '32961','18586','79307','15492')
     intersect
      select ca_zip
      from (SELECT substring(ca."ca_zip",1,5) ca_zip,count(*) cnt
            FROM "postgrestest"."customer_address" ca, "postgrestest"."customer" c
            WHERE ca."ca_address_sk" = c."c_current_addr_sk" and
                  c."c_preferred_cust_flag"='Y'
            group by ca."ca_zip"
            having count(*) > 10)A1)A2) as V1
 where ss."ss_store_sk" = s."s_store_sk"
  and ss."ss_sold_date_sk" = d."d_date_sk"
  and d."d_qoy" = 1 and d."d_year" = 2002
  and (substring(s."s_zip",1,2) = substring(V1."CA_ZIP",1,2))
 group by s."s_store_name"
 order by s."s_store_name"
  ) as tbl;


/*query 9*/
select case when (select count(*)
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 1 and 20) > 25437
            then (select avg(ss."ss_ext_discount_amt")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 1 and 20)
            else (select avg(ss."ss_net_profit")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 1 and 20) end bucket1 ,
       case when (select count(*)
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 21 and 40) > 22746
            then (select avg(ss."ss_ext_discount_amt")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 21 and 40)
            else (select avg(ss."ss_net_profit")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 21 and 40) end bucket2,
       case when (select count(*)
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 41 and 60) > 9387
            then (select avg(ss."ss_ext_discount_amt")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 41 and 60)
            else (select avg(ss."ss_net_profit")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 41 and 60) end bucket3,
       case when (select count(*)
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 61 and 80) > 10098
            then (select avg(ss."ss_ext_discount_amt")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 61 and 80)
            else (select avg(ss."ss_net_profit")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 61 and 80) end bucket4,
       case when (select count(*)
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 81 and 100) > 18213
            then (select avg(ss."ss_ext_discount_amt")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 81 and 100) 
            else (select avg(ss."ss_net_profit")
                  from "postgrestest"."store_sales" ss
                  where ss."ss_quantity" between 81 and 100) end bucket5
from "postgrestest"."reason" r
where r."r_reason_sk" = 1
; 


/*query 10*/
select * from (select
  cd."cd_gender",
  cd."cd_marital_status",
  cd."cd_education_status",
  count(*) cnt1,
  cd."cd_purchase_estimate",
  count(*) cnt2,
  cd."cd_credit_rating",
  count(*) cnt3,
  cd."cd_dep_count",
  count(*) cnt4,
  cd."cd_dep_employed_count",
  count(*) cnt5,
  cd."cd_dep_college_count",
  count(*) cnt6
 from
  "postgrestest"."customer" c,"postgrestest"."customer_address" ca,"postgrestest"."customer_demographics" cd
 where
  c."c_current_addr_sk" = ca."ca_address_sk" and
  ca."ca_county" in ('Walker County','Richland County','Gaines County','Douglas County','Dona Ana County') and
  cd."cd_demo_sk" = c."c_current_cdemo_sk" and
  exists (select *
          from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d
          where c."c_customer_sk" = ss."ss_customer_sk" and
                ss."ss_sold_date_sk" = d."d_date_sk" and
                d."d_year" = 2002 and
                d."d_moy" between 4 and 4+3) and
   (exists (select *
            from "postgrestest"."web_sales" ws,"postgrestest"."date_dim" d
            where c."c_customer_sk" = ws."ws_bill_customer_sk" and
                  ws."ws_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 2002 and
                  d."d_moy" between 4 ANd 4+3) or
    exists (select *
            from "postgrestest"."catalog_sales" cs,"postgrestest"."date_dim" d
            where c."c_customer_sk" = cs."cs_ship_customer_sk" and
                  cs."cs_sold_date_sk" = d."d_date_sk" and
                  d."d_year" = 2002 and
                  d."d_moy" between 4 and 4+3))
 group by cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_education_status",
          cd."cd_purchase_estimate",
          cd."cd_credit_rating",
          cd."cd_dep_count",
          cd."cd_dep_employed_count", 
          cd."cd_dep_college_count"
 order by cd."cd_gender",
          cd."cd_marital_status",
          cd."cd_education_status",
          cd."cd_purchase_estimate",
          cd."cd_credit_rating",
          cd."cd_dep_count",
          cd."cd_dep_employed_count",
          cd."cd_dep_college_count"
 ) as tbl;



/*query 16*/
select * from (select
   count(distinct cs1."cs_order_number") as "order count"
  ,sum(cs1."cs_ext_ship_cost") as "total shipping cost"
  ,sum(cs1."cs_net_profit") as "total net profit"
from
   "postgrestest"."catalog_sales" cs1
  ,"postgrestest"."date_dim" d
  ,"postgrestest"."customer_address" ca
  ,"postgrestest"."call_center" cc
where
    d."d_date" between '1999-2-01' and
           (CAST('1999-2-01' AS date) + INTERVAL '60' day)
and cs1."cs_ship_date_sk" = d."d_date_sk"
and cs1."cs_ship_addr_sk" = ca."ca_address_sk"
and ca."ca_state" = 'IL'
and cs1."cs_call_center_sk" = cc."cc_call_center_sk"
and cc."cc_county" in ('Williamson County','Williamson County','Williamson County','Williamson County',
                  'Williamson County'
)
and exists (select *
            from "postgrestest"."catalog_sales" cs2
            where cs1."cs_order_number" = cs2."cs_order_number"
              and cs1."cs_warehouse_sk" <> cs2."cs_warehouse_sk")
and not exists(select *
               from "postgrestest"."catalog_returns" cr1
               where cs1."cs_order_number" = cr1."cr_order_number")
order by count(distinct cs1."cs_order_number")
 ) as tbl limit 100;


/*query 17*/
select * from (select  i."i_item_id"
       ,i."i_item_desc"
       ,s."s_state"
       ,count(ss."ss_quantity") as store_sales_quantitycount
       ,avg(ss."ss_quantity") as store_sales_quantityave
       ,stddev_samp(ss."ss_quantity") as store_sales_quantitystdev
       ,stddev_samp(ss."ss_quantity")/avg(ss."ss_quantity") as store_sales_quantitycov
       ,count(sr."sr_return_quantity") as store_returns_quantitycount
       ,avg(sr."sr_return_quantity") as store_returns_quantityave
       ,stddev_samp(sr."sr_return_quantity") as store_returns_quantitystdev
       ,stddev_samp(sr."sr_return_quantity")/avg(sr."sr_return_quantity") as store_returns_quantitycov
       ,count(cs."cs_quantity") as catalog_sales_quantitycount ,avg(cs."cs_quantity") as catalog_sales_quantityave
       ,stddev_samp(cs."cs_quantity") as catalog_sales_quantitystdev
       ,stddev_samp(cs."cs_quantity")/avg(cs."cs_quantity") as catalog_sales_quantitycov
 from "postgrestest"."store_sales" ss 
     ,"postgrestest"."store_returns" sr
     ,"postgrestest"."catalog_sales" cs
     ,"postgrestest"."date_dim" d1
     ,"postgrestest"."date_dim" d2
     ,"postgrestest"."date_dim" d3
     ,"postgrestest"."store" s
     ,"postgrestest"."item" i
 where d1."d_quarter_name" = '1998Q1'
   and d1."d_date_sk" = ss."ss_sold_date_sk"
   and i."i_item_sk" = ss."ss_item_sk"
   and s."s_store_sk" = ss."ss_store_sk"
   and ss."ss_customer_sk" = sr."sr_customer_sk"
   and ss."ss_item_sk" = sr."sr_item_sk"
   and ss."ss_ticket_number" = sr."sr_ticket_number"
   and sr."sr_returned_date_sk" = d2."d_date_sk"
   and d2."d_quarter_name" in ('1998Q1','1998Q2','1998Q3')
   and sr."sr_customer_sk" = cs."cs_bill_customer_sk"
   and sr."sr_item_sk" = cs."cs_item_sk"
   and cs."cs_sold_date_sk" = d3."d_date_sk"
   and d3."d_quarter_name" in ('1998Q1','1998Q2','1998Q3')
 group by i."i_item_id"
         ,i."i_item_desc"
         ,s."s_state"
 order by i."i_item_id"
         ,i."i_item_desc"
         ,s."s_state"
 ) as tbl;


/*query18 */
select * from (select  i."i_item_id",
        ca."ca_country",
        ca."ca_state",
        ca."ca_county",
        avg( cast(cs."cs_quantity" as decimal(12,2))) agg1,
        avg( cast(cs."cs_list_price" as decimal(12,2))) agg2,
        avg( cast(cs."cs_coupon_amt" as decimal(12,2))) agg3,
        avg( cast(cs."cs_sales_price" as decimal(12,2))) agg4,
        avg( cast(cs."cs_net_profit" as decimal(12,2))) agg5,
        avg( cast(c."c_birth_year" as decimal(12,2))) agg6,
        avg( cast(cd1."cd_dep_count" as decimal(12,2))) agg7
 from "postgrestest"."catalog_sales" cs, "postgrestest"."customer_demographics" cd1,
      "postgrestest"."customer_demographics" cd2, "postgrestest"."customer" c, "postgrestest"."customer_address" ca, "postgrestest"."date_dim" d, "postgrestest"."item" i
 where cs."cs_sold_date_sk" = d."d_date_sk" and
       cs."cs_item_sk" = i."i_item_sk" and
       cs."cs_bill_cdemo_sk" = cd1."cd_demo_sk" and
       cs."cs_bill_customer_sk" = c."c_customer_sk" and
       cd1."cd_gender" = 'M' and
       cd1."cd_education_status" = 'College' and
       c."c_current_cdemo_sk" = cd2."cd_demo_sk" and
       c."c_current_addr_sk" = ca."ca_address_sk" and
       c."c_birth_month" in (9,5,12,4,1,10) and
       d."d_year" = 2001 and
       ca."ca_state" in ('ND','WI','AL'
                   ,'NC','OK','MS','TN')
 group by rollup (i."i_item_id", ca."ca_country", ca."ca_state", ca."ca_county")
 order by ca."ca_country",
        ca."ca_state",
        ca."ca_county",
        i."i_item_id"
  ) as tbl;

  /*query 21*/
select * from (select  *
 from(select w."w_warehouse_name"
            ,i."i_item_id"
            ,sum(case when (cast(d."d_date" as date) < cast ('1998-04-08' as date))
                        then inv."inv_quantity_on_hand"
                      else 0 end) as inv_before
            ,sum(case when (cast(d."d_date" as date) >= cast ('1998-04-08' as date))
                      then inv."inv_quantity_on_hand"
                      else 0 end) as inv_after
   from "postgrestest"."inventory" inv
       ,"postgrestest"."warehouse" w
       ,"postgrestest"."item" i
       ,"postgrestest"."date_dim" d
   where i."i_current_price" between 0.99 and 1.49
     and i."i_item_sk"          = inv."inv_item_sk"
     and inv."inv_warehouse_sk"   = w."w_warehouse_sk"
     and inv."inv_date_sk"    = d."d_date_sk"
     and d."d_date" between (cast ('1998-04-08' as date) -  INTERVAL '30' day)
                    and (cast ('1998-04-08' as date) +  INTERVAL '30' day)
   group by w."w_warehouse_name", i."i_item_id") x
 where (case when inv_before > 0
             then inv_after / inv_before
             else null
             end) between 2.0/3.0 and 3.0/2.0
 order by x."w_warehouse_name"
         ,x."i_item_id"
  ) as tbl limit 100;

/*query 24*//*long running time*/

with ssales as
(select c."c_last_name"
      ,c."c_first_name"
      ,s."s_store_name"
      ,ca."ca_state"
      ,s."s_state"
      ,i."i_color"
      ,i."i_current_price"
      ,i."i_manager_id"
      ,i."i_units"
      ,i."i_size"
      ,sum(ss."ss_sales_price") netpaid
from "postgrestest"."store_sales" ss
    ,"postgrestest"."store_returns" sr
    ,"postgrestest"."store" s
    ,"postgrestest"."item" i
    ,"postgrestest"."customer" c
    ,"postgrestest"."customer_address" ca
where ss."ss_ticket_number" = sr."sr_ticket_number"
  and ss."ss_item_sk" = sr."sr_item_sk"
  and ss."ss_customer_sk" = c."c_customer_sk"
  and ss."ss_item_sk" = i."i_item_sk"
  and ss."ss_store_sk" = s."s_store_sk"
  and c."c_current_addr_sk" = ca."ca_address_sk"
  and c."c_birth_country" <> upper(ca."ca_country")
  and s."s_zip" = ca."ca_zip"
and s."s_market_id"=7
group by c."c_last_name"
        ,c."c_first_name"
        ,s."s_store_name"
        ,ca."ca_state"
        ,s."s_state"
        ,i."i_color"
        ,i."i_current_price"
        ,i."i_manager_id"
        ,i."i_units"
        ,i."i_size")
select ssales."c_last_name"
      ,ssales."c_first_name"
      ,ssales."s_store_name"
      ,sum(netpaid) paid
from ssales
where ssales."i_color" = 'orchid'
group by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
having sum(netpaid) > (select 0.05*avg(netpaid)
                                 from ssales)
order by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
;

with ssales as
(select c."c_last_name"
      ,c."c_first_name"
      ,s."s_store_name"
      ,ca."ca_state"
      ,s."s_state"
      ,i."i_color"
      ,i."i_current_price"
      ,i."i_manager_id"
      ,i."i_units"
      ,i."i_size"
      ,sum(ss."ss_sales_price") netpaid
from "postgrestest"."store_sales" ss
    ,"postgrestest"."store_returns" sr
    ,"postgrestest"."store" s
    ,"postgrestest"."item" i
    ,"postgrestest"."customer" c
    ,"postgrestest"."customer_address" ca
where ss."ss_ticket_number" = sr."sr_ticket_number"
  and ss."ss_item_sk" = sr."sr_item_sk"
  and ss."ss_customer_sk" = c."c_customer_sk"
  and ss."ss_item_sk" = i."i_item_sk"
  and ss."ss_store_sk" = s."s_store_sk"
  and c."c_current_addr_sk" = ca."ca_address_sk"
  and c."c_birth_country" <> upper(ca."ca_country")
  and s."s_zip" = ca."ca_zip"
and s."s_market_id"=7
group by c."c_last_name"
        ,c."c_first_name"
        ,s."s_store_name"
        ,ca."ca_state"
        ,s."s_state"
        ,i."i_color"
        ,i."i_current_price"
        ,i."i_manager_id"
        ,i."i_units"
        ,i."i_size")
select ssales."c_last_name"
      ,ssales."c_first_name"
      ,ssales."s_store_name"
      ,sum(netpaid) paid
from ssales
where ssales."i_color" = 'chiffon'
group by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
having sum(netpaid) > (select 0.05*avg(netpaid)
                                 from ssales)
order by ssales."c_last_name"
        ,ssales."c_first_name"
        ,ssales."s_store_name"
;


/*query 30*/
with customer_total_return as
 (select wr."wr_returning_customer_sk" as ctr_customer_sk
        ,ca."ca_state" as ctr_state,
        sum(wr."wr_return_amt") as ctr_total_return
 from "postgrestest"."web_returns" wr
     ,"postgrestest"."date_dim" d
     ,"postgrestest"."customer_address" ca
 where wr."wr_returned_date_sk" = d."d_date_sk"
   and d."d_year" =2002
   and wr."wr_returning_addr_sk" = ca."ca_address_sk"
 group by wr."wr_returning_customer_sk"
         ,ca."ca_state")
 select * from ( select  c."c_customer_id",c."c_salutation",c."c_first_name",c."c_last_name",c."c_preferred_cust_flag"
       ,c."c_birth_day",c."c_birth_month",c."c_birth_year",c."c_birth_country",c."c_login",c."c_email_address"
       ,c."c_last_review_date_sk",ctr_total_return
 from customer_total_return ctr1
     ,"postgrestest"."customer_address" ca
     ,"postgrestest"."customer" c
 where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
                          from customer_total_return ctr2
                          where ctr1.ctr_state = ctr2.ctr_state)
       and ca."ca_address_sk" = c."c_current_addr_sk"
       and ca."ca_state" = 'IL'
       and ctr1.ctr_customer_sk = c."c_customer_sk"
 order by c."c_customer_id",c."c_salutation",c."c_first_name",c."c_last_name",c."c_preferred_cust_flag"
                  ,c."c_birth_day",c."c_birth_month",c."c_birth_year",c."c_birth_country",c."c_login",c."c_email_address"
                  ,c."c_last_review_date_sk",ctr_total_return
 ) as tbl;


 /*query 31*/ /*long running*/
 with ss as
 (select ca."ca_county",d."d_qoy", d."d_year",sum(ss."ss_ext_sales_price") as store_sales
 from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d,"postgrestest"."customer_address" ca
 where ss."ss_sold_date_sk" = d."d_date_sk"
  and ss."ss_addr_sk"=ca."ca_address_sk"
 group by ca."ca_county",d."d_qoy", d."d_year"),
 ws as
 (select ca."ca_county",d."d_qoy", d."d_year",sum(ws."ws_ext_sales_price") as web_sales
 from "postgrestest"."web_sales" ws,"postgrestest"."date_dim" d,"postgrestest"."customer_address" ca
 where ws."ws_sold_date_sk" = d."d_date_sk"
  and ws."ws_bill_addr_sk"=ca."ca_address_sk"
 group by ca."ca_county",d."d_qoy", d."d_year")
 select
        ss1."ca_county"
       ,ss1."d_year"
       ,ws2."WEB_SALES"/ws1."WEB_SALES" web_q1_q2_increase
       ,ss2."STORE_SALES"/ss1."STORE_SALES" store_q1_q2_increase
       ,ws3."WEB_SALES"/ws2."WEB_SALES" web_q2_q3_increase
       ,ss3."STORE_SALES"/ss2."STORE_SALES" store_q2_q3_increase
 from
        ss ss1
       ,ss ss2
       ,ss ss3
       ,ws ws1
       ,ws ws2
       ,ws ws3
 where
    ss1."d_qoy" = 1
    and ss1."d_year" = 2000
    and ss1."ca_county" = ss2."ca_county"
    and ss2."d_qoy" = 2
    and ss2."d_year" = 2000
 and ss2."ca_county" = ss3."ca_county"
    and ss3."d_qoy" = 3
    and ss3."d_year" = 2000
    and ss1."ca_county" = ws1."ca_county"
    and ws1."d_qoy" = 1
    and ws1."d_year" = 2000
    and ws1."ca_county" = ws2."ca_county"
    and ws2."d_qoy" = 2
    and ws2."d_year" = 2000
    and ws1."ca_county" = ws3."ca_county"
    and ws3."d_qoy" = 3
    and ws3."d_year" =2000
    and case when ws1."WEB_SALES" > 0 then ws2."WEB_SALES"/ws1."WEB_SALES" else null end
       > case when ss1."STORE_SALES" > 0 then ss2."STORE_SALES"/ss1."STORE_SALES" else null end
    and case when ws2."WEB_SALES" > 0 then ws3."WEB_SALES"/ws2."WEB_SALES" else null end
       > case when ss2."STORE_SALES" > 0 then ss3."STORE_SALES"/ss2."STORE_SALES" else null end
 order by ss1."d_year";


/*query 34*/
select c."c_last_name"
       ,c."c_first_name"
       ,c."c_salutation"
       ,c."c_preferred_cust_flag"
       ,dn."ss_ticket_number"
       ,cnt from
   (select ss."ss_ticket_number"
          ,ss."ss_customer_sk"
          ,count(*) cnt
    from "postgrestest"."store_sales" ss,"postgrestest"."date_dim" d,"postgrestest"."store" s,"postgrestest"."household_demographics" hd
    where ss."ss_sold_date_sk" = d."d_date_sk"
    and ss."ss_store_sk" = s."s_store_sk"
    and ss."ss_hdemo_sk" = hd."hd_demo_sk"
    and (d."d_dom" between 1 and 3 or d."d_dom" between 25 and 28)
    and (hd."hd_buy_potential" = '>10000' or
         hd."hd_buy_potential" = 'Unknown')
    and hd."hd_vehicle_count" > 0
    and (case when hd."hd_vehicle_count" > 0
        then hd."hd_dep_count"/ hd."hd_vehicle_count"
        else null
        end)  > 1.2
    and d."d_year" in (1998,1998+1,1998+2)
    and s."s_county" in ('Williamson County','Williamson County','Williamson County','Williamson County',
                           'Williamson County','Williamson County','Williamson County','Williamson County')
    group by ss."ss_ticket_number",ss."ss_customer_sk") dn,"postgrestest"."customer" c
    where dn."ss_customer_sk" = c."c_customer_sk"
      and cnt between 15 and 20
    order by c."c_last_name",c."c_first_name",c."c_salutation",c."c_preferred_cust_flag" desc, dn."ss_ticket_number";


    /*query 38*/

    select * from (select  count(*) from (
    select distinct c."c_last_name", c."c_first_name", d."d_date"
    from "postgrestest"."store_sales" ss, "postgrestest"."date_dim" d, "postgrestest"."customer" c
          where ss."ss_sold_date_sk" = d."d_date_sk"
      and ss."ss_customer_sk" = c."c_customer_sk"
      and d."d_month_seq" between 1212 and 1212 + 11
  intersect
    select distinct c."c_last_name", c."c_first_name", d."d_date"
    from "postgrestest"."catalog_sales" cs, "postgrestest"."date_dim" d, "postgrestest"."customer" c
          where cs."cs_sold_date_sk" = d."d_date_sk"
      and cs."cs_bill_customer_sk" = c."c_customer_sk"
      and d."d_month_seq" between 1212 and 1212 + 11
  intersect
    select distinct c."c_last_name", c."c_first_name", d."d_date"
    from "postgrestest"."web_sales" ws, "postgrestest"."date_dim" d, "postgrestest"."customer" c
          where ws."ws_sold_date_sk" = d."d_date_sk"
      and ws."ws_bill_customer_sk" = c."c_customer_sk"
      and d."d_month_seq" between 1212 and 1212 + 11
) hot_cust
 ) as tbl limit 100;

/*query 39*/

with inv as
(select foo."w_warehouse_name",foo."w_warehouse_sk",foo."i_item_sk",foo."d_moy"
       ,stdev,mean, case mean when 0 then null else stdev/mean end cov
 from(select w."w_warehouse_name",w."w_warehouse_sk",i."i_item_sk",d."d_moy"
            ,stddev_samp(inv."inv_quantity_on_hand") stdev,avg(inv."inv_quantity_on_hand") mean
      from "postgrestest"."inventory" inv
          ,"postgrestest"."item" i
          ,"postgrestest"."warehouse" w
          ,"postgrestest"."date_dim" d
      where inv."inv_item_sk" = i."i_item_sk"
        and inv."inv_warehouse_sk" = w."w_warehouse_sk"
        and inv."inv_date_sk" = d."d_date_sk"
        and d."d_year" =1998
      group by w."w_warehouse_name",w."w_warehouse_sk",i."i_item_sk",d."d_moy") foo
 where case mean when 0 then 0 else stdev/mean end > 1)
select inv1."w_warehouse_sk",inv1."i_item_sk",inv1."d_moy",inv1."MEAN", inv1."COV"
        ,inv2."w_warehouse_sk",inv2."i_item_sk",inv2."d_moy",inv2."MEAN", inv2."COV"
from inv inv1,inv inv2
where inv1."i_item_sk" = inv2."i_item_sk"
  and inv1."w_warehouse_sk" =  inv2."w_warehouse_sk"
  and inv1."d_moy"=4
  and inv2."d_moy"=4+1
order by inv1."w_warehouse_sk",inv1."i_item_sk",inv1."d_moy",inv1."MEAN",inv1."COV"
        ,inv2."d_moy",inv2."MEAN", inv2."COV"
;


/*query 41*/
select * from (select  distinct(i1."i_product_name")
 from "postgrestest"."item" i1
 where i1."i_manufact_id" between 742 and 742+40
   and (select count(*) as item_cnt
        from "postgrestest"."item" i
        where (i."i_manufact" = i1."i_manufact" and
        ((i1."i_category" = 'Women' and
        (i1."i_color" = 'orchid' or i1."i_color" = 'papaya') and
        (i1."i_units" = 'Pound' or i1."i_units" = 'Lb') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        ) or
        (i1."i_category" = 'Women' and
        (i1."i_color" = 'burlywood' or i1."i_color" = 'navy') and
        (i1."i_units" = 'Bundle' or i1."i_units" = 'Each') and
        (i1."i_size" = 'N/A' or i1."i_size" = 'extra large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'bisque' or i1."i_color" = 'azure') and
        (i1."i_units" = 'N/A' or i1."i_units" = 'Tsp') and
        (i1."i_size" = 'small' or i1."i_size" = 'large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'chocolate' or i1."i_color" = 'cornflower') and
        (i1."i_units" = 'Bunch' or i1."i_units" = 'Gross') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        ))) or
       (i."i_manufact" = i1."i_manufact" and
        ((i1."i_category" = 'Women' and
        (i1."i_color" = 'salmon' or i1."i_color" = 'midnight') and
        (i1."i_units" = 'Oz' or i1."i_units" = 'Box') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        ) or
        (i1."i_category" = 'Women' and
        (i1."i_color" = 'snow' or i1."i_color" = 'steel') and
        (i1."i_units" = 'Carton' or i1."i_units" = 'Tbl') and
        (i1."i_size" = 'N/A' or i1."i_size" = 'extra large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'purple' or i1."i_color" = 'gainsboro') and
        (i1."i_units" = 'Dram' or i1."i_units" = 'Unknown') and
        (i1."i_size" = 'small' or i1."i_size" = 'large')
        ) or
        (i1."i_category" = 'Men' and
        (i1."i_color" = 'metallic' or i1."i_color" = 'forest') and
        (i1."i_units" = 'Gram' or i1."i_units" = 'Ounce') and
        (i1."i_size" = 'petite' or i1."i_size" = 'medium')
        )))) > 0
 order by i1."i_product_name"
  ) as tbl;


/*query 42*/
select * from (select  d."d_year"
        ,i."i_category_id"
        ,i."i_category"
        ,sum(ss."ss_ext_sales_price")
 from   "postgrestest"."date_dim" d
        ,"postgrestest"."store_sales" ss
        ,"postgrestest"."item" i 
 where d."d_date_sk" = ss."ss_sold_date_sk"
        and ss."ss_item_sk" = i."i_item_sk"
        and i."i_manager_id" = 1
        and d."d_moy"=12
        and d."d_year"=1998
 group by       d."d_year"
                ,i."i_category_id"
                ,i."i_category"
 order by       sum(ss."ss_ext_sales_price") desc,d."d_year"
                ,i."i_category_id"
                ,i."i_category"
 ) as tbl;


/*query 43*/
select * from (select  s."s_store_name", s."s_store_id",
        sum(case when (d."d_day_name"='Sunday') then ss."ss_sales_price" else null end) sun_sales,
        sum(case when (d."d_day_name"='Monday') then ss."ss_sales_price" else null end) mon_sales,
        sum(case when (d."d_day_name"='Tuesday') then ss."ss_sales_price" else  null end) tue_sales,
        sum(case when (d."d_day_name"='Wednesday') then ss."ss_sales_price" else null end) wed_sales,
        sum(case when (d."d_day_name"='Thursday') then ss."ss_sales_price" else null end) thu_sales,
        sum(case when (d."d_day_name"='Friday') then ss."ss_sales_price" else null end) fri_sales,
        sum(case when (d."d_day_name"='Saturday') then ss."ss_sales_price" else null end) sat_sales
 from "postgrestest"."date_dim" d, "postgrestest"."store_sales" ss, "postgrestest"."store" s
 where d."d_date_sk" = ss."ss_sold_date_sk" and
       s."s_store_sk" = ss."ss_store_sk" and
       s."s_gmt_offset" = -5 and
       d."d_year" = 1998
 group by s."s_store_name", s."s_store_id"
 order by s."s_store_name", s."s_store_id",sun_sales,mon_sales,tue_sales,wed_sales,thu_sales,fri_sales,sat_sales
  ) as tbl;




