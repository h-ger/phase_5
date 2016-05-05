class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @completed_shifts = Shift.completed.chronological.paginate(page: params[:page]).per_page(10)
    @incomplete_shifts = Shift.incomplete.chronological.paginate(page: params[:page]).per_page(10)
    if logged_in? && current_user.role == "manager"
      @my_store_incomplete_shifts = Shift.incomplete.for_store(current_user.employee.current_assignment.store_id).chronological.paginate(page: params[:page]).per_page(10)
      @my_store_completed_shifts = Shift.completed.for_store(current_user.employee.current_assignment.store_id).chronological.paginate(page: params[:page]).per_page(10)
    elsif logged_in? && current_user.role == "employee"
      @my_past_shifts = Shift.past.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)
      @my_upcoming_shifts = Shift.upcoming.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)
    end
  end

  def show
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    
    if @shift.save
      redirect_to shift_path(@shift), notice: "Successfully created #{@shift.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to shift_path(@shift), notice: "Successfully updated #{@shift.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Successfully removed #{@shift.name} from the AMC system."
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :note)
  end
end