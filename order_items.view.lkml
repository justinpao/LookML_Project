view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: returned_item {
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
  }


  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: successful_delivery {
    type:  yesno
    sql: ${delivered_date} IS NOT NULL ;;
  }

  dimension: packaging_time {
    type: number
    sql: DATEDIFF(days,${created_raw}, ${shipped_raw});;
  }

  measure: sum_total_lead_time {
    type: sum
    sql: ${total_lead_time} ;;
  }

  dimension: lead_time_tiers {
    type: tier
    tiers: [0,3,6,9,12,15,18,21]
    style: integer
    sql: ${total_lead_time} ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: sum_sale_price {
    type:  sum
    sql: ${sale_price}  ;;
    value_format: "$#.00;($#.00)"
    drill_fields: [order_id,created_date,returned_item]
    filters: {
      field: returned_item
      value: "No"
    }
  }



  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: delivery_time  {
    type: number
    sql: DATEDIFF(days,${shipped_raw},${delivered_raw}) ;;
  }
  dimension: total_lead_time {
   type: number
    sql: ${delivery_time} + ${packaging_time} ;;
    drill_fields: [order_id,successful_delivery,user_id]
  }

  measure: min_total_lead_time {
    type: min
    sql: ${total_lead_time} ;;
    drill_fields: [order_id,successful_delivery,user_id]
    filters: {
      field: successful_delivery
      value: "Yes"
    }
  }

  measure: max_total_lead_time {
    type: max
    sql: ${total_lead_time} ;;
    drill_fields: [order_id,successful_delivery,user_id]
    filters: {
      field: successful_delivery
      value: "Yes"
    }
  }

  measure: average_total_lead_time {
    type:average
    sql: ${total_lead_time} ;;
    drill_fields: [order_id,successful_delivery,user_id]
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
