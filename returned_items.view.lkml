view: returned_items_1 {
  derived_table: {
    sql: SELECT
        order_items.order_id  AS "order_items.order_id",
        order_items.inventory_item_id  AS "order_items.inventory_item_id",
        DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.returned_at )) AS "order_items.returned_date",
        order_items.sale_price  AS "order_items.sale_price"
      FROM public.order_items  AS order_items
      INNER JOIN public.users  AS users ON order_items.user_id = users.id

      WHERE ((DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.returned_at ))) IS NOT NULL) AND (users.country = 'USA')
      GROUP BY 1,2,3,4
      ORDER BY 3 DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_order_id {
    type: number
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
    fields: [order_items_order_id, order_items_inventory_item_id, order_items_returned_date, order_items_sale_price]
  }
}
