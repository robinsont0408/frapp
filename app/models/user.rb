class User < ApplicationRecord
  enum role: %i[user vip admin]
  after_initialize :set_default_role, if: :new_record?
  after_create :sign_up_for_mailing_list

  attr_accessor :stripeToken

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def pay_with_card
    if stripeToken.nil?
      errors[:base] << 'Could not verify card.'
      raise ActiveRecord::RecordInvalid, self
    end
    customer = Stripe::Customer.create(
      email: email,
      card: stripeToken
    )
    price = Rails.application.secrets.product_price
    title = Rails.application.secrets.product_title
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: price.to_s,
      description: title.to_s,
      currency: 'usd'
    )
    Rails.logger.info("Stripe transaction for #{email}") if charge[:paid] == true
  rescue Stripe::InvalidRequestError => e
    errors[:base] << e.message
    raise ActiveRecord::RecordInvalid, self
  rescue Stripe::CardError => e
    errors[:base] << e.message
    raise ActiveRecord::RecordInvalid, self
  end

  def sign_up_for_mailing_list
    MailingListSignupJob.perform_later(self)
  end

  def subscribe
    mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    list_id = Rails.application.secrets.mailchimp_list_id
    result = mailchimp.lists(list_id).members.create(
      body: {
        email_address: email,
        status: 'subscribed'
      }
    )
    Rails.logger.info("Subscribed #{email} to MailChimp") if result
  end

  def name
    #   "User #{ids}"
    'User id'
  end

  def mailboxer_email(_object)
    nil
  end

  def new
    @recipients = User.all - [current_user]
  end

  def create
    recipient = User.find(params[:user_id])
    receipt = current_user.send_message(recipient, params[:body], params[:subject])
    redirect_to conversation_path(receipt.conversation)
  end

  def address; end

  def city; end

  def state; end

  def zip; end
end
