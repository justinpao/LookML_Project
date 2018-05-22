view: returned_items {
  derived_table: {
    sql: SELECT
        order_items.order_id  AS "order_items.order_id",
        DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.returned_at )) AS "order_items.returned_date",
        order_items.sale_price  AS "order_items.sale_price"
      FROM public.order_items  AS order_items

      WHERE ((DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.returned_at ))) IS NOT NULL)
      GROUP BY 1,2,3
      ORDER BY 2 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*,order_items_returned_date]
  }

  dimension: returned_items_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."order_items.order_id" ;;
  }


  dimension: order_items_inventory_item_id {
    type: number
    sql: ${TABLE}."order_items.inventory_item_id" ;;
  }

  dimension: order_items_returned_date {
    type: date
    sql: ${TABLE}."order_items.returned_date" ;;
  }

  dimension: order_items_sale_price {
    type: number
    sql: ${TABLE}."order_items.sale_price" ;;
  }

  set: detail {
    fields: [returned_items_id, order_items_inventory_item_id, order_items_returned_date, order_items_sale_price]
  }
}
