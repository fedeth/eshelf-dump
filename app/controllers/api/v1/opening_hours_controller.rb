class Api::V1::OpeningHoursController < ApplicationController
  include ErrorHandling
  include ShopsHelper

  def update_week_opening_hours
    if current_shop.present?
      if params[:week_opening_hours].present?

        week_openings = params[:week_opening_hours]
        openings = week_openings.each_with_index.map do |wo, i|
          wo.map do |o|
            o[:week_day] = i + 1
            o
          end
        end
        openings.flatten!

        openings_to_update = openings.select { |o| o[:id].present? && o[:updated].present? }
        opening_ids_to_update = openings_to_update.map { |o| o[:id] }
        opening_info_for_update = openings_to_update.map do |o|
          o[:open_time] = Time.parse(o[:open_time])
          o[:close_time] = Time.parse(o[:close_time])
          o.except(:updated)
        end
        
        openings_to_create = openings.select { |o| o[:id].nil? }.map do |o|
          o[:shop_id] = current_shop.id
          o[:open_time] = Time.parse(o[:open_time])
          o[:close_time] = Time.parse(o[:close_time])
          o
        end

        ActiveRecord::Base.transaction do
          begin
            # delete
            OpeningHour.delete(params[:deleted_openings_ids])
            # update existing
            OpeningHour.update(opening_ids_to_update, opening_info_for_update.as_json)
            # create new
            OpeningHour.create(openings_to_create.as_json)
          rescue Exception => e
            respond_with_error('db_transaction_failed', e)
          end
        end

        respond_to do |format|
          format.json { render json: { opening_hours: get_current_shop_opening_hours } }
        end
      else
        respond_with_error('invalid_data_format')
      end
    else
      respond_with_error('invalid_current_shop')
    end
  end

  private
    def permitted_params
      params.reject{|_, v| v.blank?}.permit(:week_opening_hours, :deleted_openings_ids)
    end

end