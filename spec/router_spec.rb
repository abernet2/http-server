require_relative '../router'
describe 'Router' do 
  let(:router) {Router.new}

  it 'should take a proc and assign it to a name' do 
    router.add('test') { 12 }
    expect(router['test']).to eq 12
  end

  it 'should be able to deal with args' do
    router.add('sum') { |args| args[:x] + args[:y] }
    args = {x: 4, y: 5}
    expect(router['sum', args]).to eq 9
  end
end