# encoding: UTF-8
require 'selenium-webdriver'
require 'test/unit'
require 'shoulda'

WAIT = Selenium::WebDriver::Wait.new(timeout: 80)
$driver = Selenium::WebDriver.for :firefox
$driver.manage().window().maximize()
$driver.get 'http://gmail.com'

def driver
  $driver
end

def login(email_id, passwd)
  WAIT.until { driver.find_element(:id, 'Email') }
  driver.find_element(:id, 'Email').clear
  driver.find_element(:id, 'Email').send_keys "#{email_id}"
  driver.find_element(:id, 'Passwd').clear
  driver.find_element(:id, 'Passwd').send_keys "#{passwd}"
  driver.find_element(:id, 'signIn').click
end

def login_success(email_id, passwd)
  login(email_id , passwd)
  signouts
end

def login_error(email_id , passwd)
  login(email_id , passwd)
  error = WAIT.until { driver.find_element(:id, 'errormsg_0_Passwd') }
  if error then false end
end

def signouts
  sleep 10
  driver.find_element(:css, '.gb_K.gbii').click
  driver.find_element(:id, 'gb_71').click
  WAIT.until { driver.find_element(:id, 'signIn') }
end

def quit
  driver.quit
end

class SeleniumY < Test::Unit::TestCase
  # Below hash contains invalid username and password to check gmail login functionality
  login_data = { 'pat.sourabh' => 'asdfsaf', 'asdfasd@gmail.com' => '!password*',
    'test-manual+professional@gmail.com' => '!@#$1221'}

  context 'Gmail test' do

    should 'check login error functionality' do
      login_data.each do |key , value|
        assert_equal(false, login_error("#{key}", "#{value}"), 'Login information incorrect')
        sleep 3
      end
    end

    should 'check valid login and logout' do
      login_success('<valid_email_id>', '<valid_password>')
    end

    should 'quit browser' do
      quit
    end
  end
end
