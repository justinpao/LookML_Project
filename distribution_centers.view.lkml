view: distribution_centers {
  sql_table_name: public.distribution_centers ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }
  dimension: location {
    type:  location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude};;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }


  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }
  measure: distance_between_distribution_center_and_user {
    type: number
    sql: 2 * 3961 * asin(sqrt((sin(radians((${latitude} - ${users.latitude}) / 2))) ^ 2 + cos(radians(${users.latitude})) * cos(radians(${latitude})) * (sin(radians((${longitude} - ${users.longitude}) / 2))) ^ 2))
      ;;
  }

}
