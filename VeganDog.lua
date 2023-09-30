Player = {}
Dog = {}
Food = {nuts = 5, banana = 30, superCookie = 60}
Price = {nuts = 5, banana = 30, superCookie = 60}

-- Player
function Player:new(name)
    if type(name) ~= "string" then
        print('string is not a string')
        return
    end
    local newObj = {
        Name = name,
        Cash = 100,
        Inventory = {nuts = 0, banana = 0, superCookie = 0},
        Energy = 100
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function Player:rename(name)
    if type(name) ~= "string" then
        print('string is not a string')
        return
    end
    self['Name'] = name
end

function Player:makeMoney(payment)
    if self['Energy'] < 50 then
        print('You do not have enough energy')
        return
    end
    self['Energy'] = self['Energy'] - 50
    self['Cash'] = self['Cash'] + payment
end

function Player:buyFood(food)
    if Food[food] then
        self['Inventory'][food] = self['Inventory'][food] + 1
        self['Cash'] = self['Cash'] - Price[food]
    else
        print('There is no such food')
        return
    end
end

function Player:getFood(food)
    if Food[food] then
        local result = Food[food]
        self['Inventory'][food] = self['Inventory'][food] - 1
        return result
    else
        print('There is no food')
        return
    end
end

function Player:playWithDog(dog)
    if type(dog) ~="table" then
        print('it is not a dog')
        return
    end
    if self['Energy'] < 15 then
        print('You do not have enough energy')
        return
    end
    dog['Happiness'] = dog['Happiness'] + 30
    self['Energy'] = self['Energy'] - 15
end

function Player:sleep()
    self['Energy'] = self['Energy'] + 80
    if self['Energy'] > 100 then
        self['Energy'] = 100
    end
end

function Player:showInventory()
    io.write("Your inventory:\n")
    for key, value in pairs(self['Inventory']) do
        io.write("item: ", key, "\tquantity: ", value, "\n")
    end
    io.write("\n")
    GetInput()
end

function Player:showStatus()
    io.write('Name: ', self["Name"], "\n")
    io.write('Cash: ', self["Cash"], "\n")
    io.write('Energy: ', self["Energy"], "\n")

    GetInput()
end

--Dog
function Dog:new(name)
    if type(name) ~= "string" then
        print('string is not a string')
        return
    end
    local newObj = {
        Name = name,
        Hunger = 0,
        Happiness = 100
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function Dog:rename(name)
    if type(name) ~= 'string' then
        print('string is not a string')
    end
    self['Name'] = name
end

function Dog:eat(foodAmount)
    if type(foodAmount) ~= 'number' then
        print('food is not number')
    end
    local result = self['Hunger'] - foodAmount
    if result < 0 then
        result = 0
    end
    self['Hunger'] = result
end

function Dog:makeSound()
    print('woof')
    GetInput()
end

function Dog:showStatus()
    io.write('Name: ', self["Name"], "\n")
    io.write('Hunger: ', self["Hunger"], "\n")
    io.write('Happiness: ', self["Happiness"], "\n")

    GetInput()
end

function Dog:sleep()
    self['Happiness'] = self["Happiness"] - 40
    self['Hunger'] = self['Hunger'] + 40
    if self['Happiness'] < 0 then
        self['Happiness'] = 0
    end
    if self['Hunger'] > 100 then
        self['Hunger'] = 100
    end
end

-- Слова для печатания
Words = {
    voice = function () PlayerDog:makeSound() end,
    renamedog = function ()
        io.write("print new name here:")
        local name = io.read()
        if(name == nil or type(name) ~="string") then
            print("name cannot be nothing")
            return
        end
        PlayerDog:rename(name)
        end,
    renameyourself = function ()
        io.write("print new name here:")
        local name = io.read()
        if(name == nil or type(name) ~="string") then
            print("name cannot be nothing")
            return
        end
        MainPlayer:rename(name)
        end,
    sleep = function () 
        MainPlayer:sleep()
        PlayerDog:sleep()
     end,
    feed = function ()
        io.write("print food that you want to give a dog:")
        local food = io.read()
        local foodAmount = MainPlayer:getFood(food)
        if type(foodAmount) ~="number" or foodAmount == nil then
            io.write("You don't have that food")
            return
        end
        PlayerDog:eat(foodAmount)
    end,
    showinventory = function () MainPlayer:showInventory() end,
    mystatus = function () MainPlayer:showStatus() end,
    dogstatus = function () PlayerDog:showStatus() end,
    dojob = function () MainPlayer:makeMoney(30) end,
    playwithdog = function () MainPlayer:playWithDog(PlayerDog) end,
    buyfood = function ()
        io.write("Prices\n")
        for key, value in pairs(Price) do
            io.write("item:", key, "\t\tPrice:", value, "\n")
        end
        io.write("Your cash:", MainPlayer["Cash"], "\n")
        io.write("type item that you want to buy: ")
        local food = io.read()
        if Food[food] then
            MainPlayer:buyFood(food)
            ClearConsole()
        else
            print("there is not such food")
            ClearConsole()
        end
    end,
    help = function ()
        io.write(' List of commands:\n voice\n rename dog\n rename yourself\n sleep\n feed\n show inventory\n my status\n dog status\n do job\n play with dog\n buy food\n help\n exit\n')
    end,
    exit = function () return end
}

function ClearConsole()
    if not os.execute("clear") then
        os.execute("cls")
    elseif not os.execute("cls") then
        for i = 1,25 do
            print("\n\n")
        end
    end
end

function GetInput()
    print("press enter to continue")
    ---@diagnostic disable-next-line: discard-returns
    io.read()
    ClearConsole()
end

MainPlayer = {}
PlayerDog = {}


repeat
    io.write('Enter your name: ')
    local name = io.read()
    if type(name) ~= "string" then
        ClearConsole()
        print('name is invalid')
    else
       MainPlayer = Player:new(name)
       io.write('Player name is ', name, "\n")
    end
until type(name) == "string"



repeat
    io.write('Enter name of your dog: ')
    local name = io.read()
    if type(name) ~= "string" then
        ClearConsole()
        print('name is invalid')
    else
       PlayerDog = Dog:new(name)
       io.write('Dog name is ', name, "\n")
    end
until type(name) == "string"

ClearConsole()

repeat
    local typed = io.read()
    if typed == nil or typed == '' then
        ClearConsole()
        print("you typed nothing\nif you don't know commands type \"help\"")
    else
        typed = string.lower(typed)
        typed = string.gsub(typed, "%s+", "")
        if typed == 'exit' then
            break
        end
        if Words[typed] then
            ClearConsole()
            Words[typed]()
        else
            print("This game do not have this command\nif you don't know commands type \"help\"")
        end
    end
until typed == Words['exit']

print("Exit from programm")
