namespace :services do
  task seguimiento: :environment do
    @users = User.where(active: 1)
    @users.each do |user|
      random = Random.rand(1...28)
      case random
      when 1
        AccountMailer.frase1(user.email, user.user_information.name).deliver
      when 2
        AccountMailer.frase2(user.email, user.user_information.name).deliver
      when 3
        AccountMailer.frase3(user.email, user.user_information.name).deliver
      when 4
        AccountMailer.frase4(user.email, user.user_information.name).deliver
      when 5
        AccountMailer.frase5(user.email, user.user_information.name).deliver
      when 6
        AccountMailer.frase6(user.email, user.user_information.name).deliver
      when 7
        AccountMailer.frase7(user.email, user.user_information.name).deliver
      when 8
        AccountMailer.frase8(user.email, user.user_information.name).deliver
      when 9
        AccountMailer.frase9(user.email, user.user_information.name).deliver
      when 10
        AccountMailer.frase10(user.email, user.user_information.name).deliver
      when 11
        AccountMailer.frase11(user.email, user.user_information.name).deliver
      when 12
        AccountMailer.frase12(user.email, user.user_information.name).deliver
      when 13
        AccountMailer.frase13(user.email, user.user_information.name).deliver
      when 14
        AccountMailer.frase14(user.email, user.user_information.name).deliver
      when 15
        AccountMailer.frase15(user.email, user.user_information.name).deliver
      when 16
        AccountMailer.frase16(user.email, user.user_information.name).deliver
      when 17
        AccountMailer.frase17(user.email, user.user_information.name).deliver
      when 18
        AccountMailer.frase18(user.email, user.user_information.name).deliver
      when 19
        AccountMailer.frase19(user.email, user.user_information.name).deliver
      when 20
        AccountMailer.frase20(user.email, user.user_information.name).deliver
      when 21
        AccountMailer.frase21(user.email, user.user_information.name).deliver
      when 22
        AccountMailer.frase22(user.email, user.user_information.name).deliver
      when 23
        AccountMailer.frase23(user.email, user.user_information.name).deliver
      when 24
        AccountMailer.frase24(user.email, user.user_information.name).deliver
      when 25
        AccountMailer.frase25(user.email, user.user_information.name).deliver
      when 26
        AccountMailer.frase26(user.email, user.user_information.name).deliver
      when 27
        AccountMailer.frase27(user.email, user.user_information.name).deliver
      when 28
        AccountMailer.frase28(user.email, user.user_information.name).deliver
      end
    end
  end

end
