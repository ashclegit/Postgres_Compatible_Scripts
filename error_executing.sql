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


/* query 36 */ /*not working*/
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


  /* query 33 */
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
 group by i."i_manufact_id"
 order by total_sales
 ) as tbl;

 /*query 2*/

with wscs as
 (select sold_date_sk
        ,sales_price
  from  (select ws."ws_sold_date_sk" sold_date_sk
              ,ws."ws_ext_sales_price" sales_price
        from "postgrestest"."web_sales" ws 
        union all
        select cs."cs_sold_date_sk" sold_date_sk
              ,cs."cs_ext_sales_price"  sales_price
        from "postgrestest"."catalog_sales" cs) as table1),
 wswscs as
 (select d."d_week_seq",
        sum(case when (d."d_day_name"='Sunday') then sales_price else null end) sun_sales,
        sum(case when (d."d_day_name"='Monday') then sales_price else null end) mon_sales,
        sum(case when (d."d_day_name"='Tuesday') then sales_price else  null end) tue_sales,
        sum(case when (d."d_day_name"='Wednesday') then sales_price else null end) wed_sales,
        sum(case when (d."d_day_name"='Thursday') then sales_price else null end) thu_sales,
        sum(case when (d."d_day_name"='Friday') then sales_price else null end) fri_sales,
        sum(case when (d."d_day_name"='Saturday') then sales_price else null end) sat_sales
 from wscs
     ,"postgrestest"."date_dim" d
 where d."d_date_sk" = sold_date_sk
 group by d."d_week_seq")
 select d_week_seq1
       ,round(sun_sales1/sun_sales2,2)
       ,round(mon_sales1/mon_sales2,2)
       ,round(tue_sales1/tue_sales2,2)
       ,round(wed_sales1/wed_sales2,2)
       ,round(thu_sales1/thu_sales2,2)
       ,round(fri_sales1/fri_sales2,2)
       ,round(sat_sales1/sat_sales2,2)
 from
 (select wswscs."d_week_seq" d_week_seq1
        ,sun_sales sun_sales1
        ,mon_sales mon_sales1
        ,tue_sales tue_sales1
        ,wed_sales wed_sales1
        ,thu_sales thu_sales1
        ,fri_sales fri_sales1
        ,sat_sales sat_sales1
  from wswscs,"postgrestest"."date_dim" d
  where d."d_week_seq" = wswscs."d_week_seq" and
        d."d_year" = 2001) y,
 (select wswscs."d_week_seq" d_week_seq2
        ,sun_sales sun_sales2
        ,mon_sales mon_sales2
        ,tue_sales tue_sales2
        ,wed_sales wed_sales2
        ,thu_sales thu_sales2
        ,fri_sales fri_sales2
        ,sat_sales sat_sales2
  from wswscs
      ,"postgrestest"."date_dim" d
  where d."d_week_seq" = wswscs."d_week_seq" and
        d."d_year" = 2001+1) z
 where d_week_seq1=d_week_seq2-53
 order by d_week_seq1;


/*query 5*/
with ssr as
 (select s."s_store_id",
        sum(sales_price) as sales,
        sum(profit) as profit,
        sum(return_amt) as returns_amt,
        sum(net_loss) as profit_loss
 from
  ( select  ss."ss_store_sk" as store_sk,
            ss."ss_sold_date_sk"  as date_sk,
            ss."ss_ext_sales_price" as sales_price,
            ss."ss_net_profit" as profit,
            cast(0 as decimal(7,2)) as return_amt,
            cast(0 as decimal(7,2)) as net_loss
    from "postgrestest"."store_sales" ss
    union all
    select sr."sr_store_sk" as store_sk,
           sr."sr_returned_date_sk" as date_sk,
           cast(0 as decimal(7,2)) as sales_price,
           cast(0 as decimal(7,2)) as profit,
           sr."sr_return_amt" as return_amt,
           sr."sr_net_loss" as net_loss
    from "postgrestest"."store_returns" sr 
   ) salesreturns,
     "postgrestest"."date_dim" d,
     "postgrestest"."store" s
 where date_sk = d."d_date_sk"
       and d."d_date" between '1998-08-04'
                  and (CAST('1998-08-04' AS date) +  INTERVAL '14' day)
       and store_sk = s."s_store_sk"
 group by s."s_store_id")
 ,
 csr as
 (select cp."cp_catalog_page_id",
        sum(sales_price) as sales,
        sum(profit) as profit,
        sum(return_amt) as returns_amt,
        sum(net_loss) as profit_loss
 from
  ( select  cs."cs_catalog_page_sk" as page_sk,
            cs."cs_sold_date_sk"  as date_sk,
            cs."cs_ext_sales_price" as sales_price,
            cs."cs_net_profit" as profit,
            cast(0 as decimal(7,2)) as return_amt,
            cast(0 as decimal(7,2)) as net_loss
    from "postgrestest"."catalog_sales" cs
    union all
    select cr."cr_catalog_page_sk" as page_sk,
           cr."cr_returned_date_sk" as date_sk,
           cast(0 as decimal(7,2)) as sales_price,
           cast(0 as decimal(7,2)) as profit,
           cr."cr_return_amount" as return_amt,
           cr."cr_net_loss" as net_loss
    from "postgrestest"."catalog_returns" cr
   ) salesreturns,
     "postgrestest"."date_dim" d,
     "postgrestest"."catalog_page" cp
 where date_sk = d."d_date_sk"
       and d."d_date" between '1998-08-04'
                  and (CAST('1998-08-04' AS date) + INTERVAL '14' day)
       and page_sk = cp."cp_catalog_page_sk"
       group by cp."cp_catalog_page_id")
 ,
 wsr as
 (select web."web_site_id",
        sum(sales_price) as sales,
        sum(profit) as profit,
        sum(return_amt) as returns_amt,
        sum(net_loss) as profit_loss
 from
  ( select  ws."ws_web_site_sk" as wsr_web_site_sk,
            ws."ws_sold_date_sk"  as date_sk,
            ws."ws_ext_sales_price" as sales_price,
            ws."ws_net_profit" as profit,
            cast(0 as decimal(7,2)) as return_amt,
            cast(0 as decimal(7,2)) as net_loss
    from "postgrestest"."web_sales" ws
    union all
    select ws."ws_web_site_sk" as wsr_web_site_sk,
           wr."wr_returned_date_sk" as date_sk,
           cast(0 as decimal(7,2)) as sales_price,
           cast(0 as decimal(7,2)) as profit,
           wr."wr_return_amt" as return_amt,
           wr."wr_net_loss" as net_loss
    from "postgrestest"."web_returns" wr left outer join "postgrestest"."web_sales" ws on
         ( wr."wr_item_sk" = ws."ws_item_sk"
           and wr."wr_order_number" = ws."ws_order_number")
   ) salesreturns,
     "postgrestest"."date_dim" d,
     "postgrestest"."web_site" web
 where date_sk = d."d_date_sk"
       and d."d_date" between '1998-08-04'
                  and (CAST('1998-08-04' AS date) + INTERVAL '14' day)
       and wsr_web_site_sk = web."web_site_sk"
 group by web."web_site_id")
 select * from ( select  channel
        , id
        , sum(sales) as sales
        , sum(returns_amt) as returns_amt1
        , sum(profit) as profit
 from
 (select 'store channel' as channel
        , 'store' || "s_store_id" as id
        , sales
        , returns_amt
        , (profit - profit_loss) as profit
 from   ssr
 union all
 select 'catalog channel' as channel
        , 'catalog_page' || "cp_catalog_page_id" as id
        , sales
        , returns_amt
        , (profit - profit_loss) as profit
 from  csr
 union all
 select 'web channel' as channel
        , 'web_site' || "web_site_id" as id
        , sales
        , returns_amt
        , (profit - profit_loss) as profit
 from   wsr
 ) x
  group by rollup (channel, id)
 order by channel
         ,id
  ) as tbl;  

/*query 11*/
with year_total as (
 select c."c_customer_id" customer_id
       ,c."c_first_name" customer_first_name
       ,c."c_last_name" customer_last_name
       ,c."c_preferred_cust_flag" customer_preferred_cust_flag
       ,c."c_birth_country" customer_birth_country
       ,c."c_login" customer_login
       ,c."c_email_address" customer_email_address
       ,d."d_year" dyear
       ,sum(ss."ss_ext_list_price"-ss."ss_ext_discount_amt") year_total
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
       ,sum(ws."ws_ext_list_price"-ws."ws_ext_discount_amt") year_total
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
 select * from ( select
                  t_s_secyear.customer_id
                 ,t_s_secyear.customer_first_name
                 ,t_s_secyear.customer_last_name 
                 ,t_s_secyear.customer_email_address
 from year_total t_s_firstyear
     ,year_total t_s_secyear
     ,year_total t_w_firstyear
     ,year_total t_w_secyear
 where t_s_secyear.customer_id = t_s_firstyear.customer_id
         and t_s_firstyear.customer_id = t_w_secyear.customer_id
         and t_s_firstyear.customer_id = t_w_firstyear.customer_id
         and t_s_firstyear.sale_type = 's'
         and t_w_firstyear.sale_type = 'w'
         and t_s_secyear.sale_type = 's'
         and t_w_secyear.sale_type = 'w'
         and t_s_firstyear.dyear = 2001
         and t_s_secyear.dyear = 2001+1
         and t_w_firstyear.dyear = 2001
         and t_w_secyear.dyear = 2001+1
         and t_s_firstyear.year_total > 0
         and t_w_firstyear.year_total > 0
         and case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else 0.0 end
             > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else 0.0 end
 order by t_s_secyear.customer_id
         ,t_s_secyear.customer_first_name
         ,t_s_secyear.customer_last_name
         ,t_s_secyear.customer_email_address
 ) as tbl;

 /*query 12*/
 select * from (select  i."i_item_id"
      ,i."i_item_desc"
      ,i."i_category"
      ,i."i_class"
      ,i."i_current_price"
      ,sum(ws."ws_ext_sales_price") as itemrevenue
      ,sum(ws."ws_ext_sales_price")*100/sum(sum(ws."ws_ext_sales_price")) over
          (partition by i."i_class") as revenueratio
from
        "postgrestest"."web_sales" ws
        ,"postgrestest"."item" i
        ,"postgrestest"."date_dim" d
where
        ws."ws_item_sk" = i."i_item_sk"
        and i."i_category" in ('Jewelry', 'Sports', 'Books')
        and ws."ws_sold_date_sk" = d."d_date_sk"
        and d."d_date" between '2001-01-12'
                                and (CAST('2001-01-12' AS date) +  INTERVAL '30' day )
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
        ,revenueratio
 ) as tbl LIMIT 100;

 /*query20*/
 select * from (select  i."i_item_id"
       ,i."i_item_desc"
       ,i."i_category"
       ,i."i_class"
       ,i."i_current_price"
       ,sum(cs."cs_ext_sales_price") as itemrevenue
       ,sum(cs."cs_ext_sales_price")*100/sum(sum(cs."cs_ext_sales_price")) over
           (partition by i."i_class") as revenueratio
 from   "postgrestest"."catalog_sales" cs
     ,"postgrestest"."item" i
     ,"postgrestest"."date_dim" d
 where cs."cs_item_sk" = i."i_item_sk"
   and i."i_category" in ('Jewelry', 'Sports', 'Books')
   and cs."cs_sold_date_sk" = d."d_date_sk"
 and d."d_date" between '2001-01-12'
                                and (cast('2001-01-12' as date) + INTERVAL '30' day)
 group by i."i_item_id"
         ,i."i_item_desc"
         ,i."i_category"
         ,i."i_class"
         ,i."i_current_price"
 order by i."i_category"
         ,i."i_class"
         ,i."i_item_id"
         ,i."i_item_desc"
         ,revenueratio
 )as tbl limit 100;


/*query 23*/
with frequent_ss_items as
 (select substring(i."i_item_desc",1,30) itemdesc,i."i_item_sk" item_sk,d."d_date" solddate,count(*) cnt
  from "postgrestest"."store_sales" ss
      ,"postgrestest"."date_dim" d
      ,"postgrestest"."item" i
  where ss."ss_sold_date_sk" = d."d_date_sk"
    and ss."ss_item_sk" = i."i_item_sk"
    and d."d_year" in (1999,1999+1,1999+2,1999+3)
  group by substring(i."i_item_desc",1,30),i."i_item_sk",d."d_date"
  having count(*) >4),
 max_store_sales as
 (select max(csales) tpcds_cmax
  from (select c."c_customer_sk",sum(ss."ss_quantity"*ss."ss_sales_price") csales
        from "postgrestest"."store_sales" ss
            ,"postgrestest"."customer" c
            ,"postgrestest"."date_dim" d
        where ss."ss_customer_sk" = c."c_customer_sk"
         and ss."ss_sold_date_sk" = d."d_date_sk"
         and d."d_year" in (1999,1999+1,1999+2,1999+3)
        group by c."c_customer_sk")),
 best_ss_customer as
 (select c."c_customer_sk",sum(ss."ss_quantity"*ss."ss_sales_price") ssales
  from "postgrestest"."store_sales" ss
      ,"postgrestest"."customer" c
  where ss."ss_customer_sk" = c."c_customer_sk"
  group by c."c_customer_sk"
  having sum(ss."ss_quantity"*ss."ss_sales_price") > (95/100.0) * (select
  *
from
 max_store_sales))
 select * from ( select  sum(sales)
 from (select cs."cs_quantity"*cs."cs_list_price" sales
       from "postgrestest"."catalog_sales" cs
           ,"postgrestest"."date_dim" d
       where d."d_year" = 1999
         and d."d_moy" = 1
         and cs."cs_sold_date_sk" = d."d_date_sk"
         and cs."cs_item_sk" in (select fss."ITEM_SK" from frequent_ss_items fss)
         and cs."cs_bill_customer_sk" in (select bss."c_customer_sk" from best_ss_customer bss)
      union all
      select ws."ws_quantity"*ws."ws_list_price" sales
       from "postgrestest"."web_sales" ws
           ,"postgrestest"."date_dim" d
       where d."d_year" = 1999
         and d."d_moy" = 1
         and ws."ws_sold_date_sk" = d."d_date_sk"
         and ws."ws_item_sk" in (select fss."ITEM_SK" from frequent_ss_items fss)
         and ws."ws_bill_customer_sk" in (select bss."c_customer_sk" from best_ss_customer bss))
  );

  /*query 27*/
  select * from (select  i."i_item_id",
        s."s_state", grouping(s."s_state") g_state,
        avg(ss."ss_quantity") agg1,
        avg(ss."ss_list_price") agg2,
        avg(ss."ss_coupon_amt") agg3,
        avg(ss."ss_sales_price") agg4
 from "postgrestest"."store_sales" ss, "postgrestest"."customer_demographics" cd, "postgrestest"."date_dim" d, "postgrestest"."store" s, "postgrestest"."item" i
 where ss."ss_sold_date_sk" = d."d_date_sk" and
       ss."ss_item_sk" = i."i_item_sk" and
       ss."ss_store_sk" = s."s_store_sk" and
       ss."ss_cdemo_sk" = cd."cd_demo_sk" and
       cd."cd_gender" = 'F' and
       cd."cd_marital_status" = 'W' and
       cd."cd_education_status" = 'Primary' and
       d."d_year" = 1998 and
       s."s_state" in ('TN','TN', 'TN', 'TN', 'TN', 'TN')
 group by rollup (i."i_item_id", s."s_state")
 order by i."i_item_id"
         ,s."s_state"
  ) as tbl limit 100;
