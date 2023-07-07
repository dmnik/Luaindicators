Settings= 
{ 
    Name = "Darvas",
    Period = 5,
    line = {
        {
            Name = "High",
            Color = RGB(0, 172, 220),
            Type = TYPE_LINE,
            Width = 2
        },
        
        {
            Name = "Low",
            Color = RGB(255, 0, 0),
            Type = TYPE_LINE,
            Width = 2
        },
    }
}

function Init()
    return 2
end

function HV(i, count)
    local max = H(i);
    
    if(i - count < 0) then
        return -1;
    end;
    
    for a = 1, count-1 do
        if(max < (H(i - a))) then
            max = H(i - a);
        end;
    end;
    
    return max;
end;

function LV(i, count)
    local min = L(i);
    
    if(i - count < 0) then
        return -1;
    end;
    
    for a = 1, count-1 do
        if(min > L(i - a)) then
            min = L(i - a);
        end;
    end;
    
    return min;
end;

function Now(index)
    local dt = {};
    local flag = false;
    dt.day,dt.month,dt.year,dt.hour,dt.min,dt.sec = string.match(getInfoParam('TRADEDATE')..' '..getInfoParam('SERVERTIME'),"(%d*).(%d*).(%d*) (%d*):(%d*):(%d*)");
    return tonumber(dt.year) == tonumber(T(index).year) and tonumber(dt.month) == tonumber(T(index).month) and tonumber(dt.day) == tonumber(T(index).day) and tonumber(dt.hour) == tonumber(T(index).hour) and tonumber(dt.min) == tonumber(T(index).min);
end

local h = -1;
local l = -1;
local lh;
local ll;
local dh;
local dl;
local start = false;
local flag = true;
local pl = false;
local ph = false;
function OnCalculate(i)
    
    lh = h;
    ll = l;
    
    if(not start) then
        start = true;
        
        h = H(i);
        l = L(i);
        
        return h, l;
    end
    
    if(ph) then
        if(H(i) > HV(i-1, Settings.Period)) then
            dl = ll;
            h = H(i);
            flag = true;
        end
        ph = false;
    end
    
    if(pl) then
        if(L(i) < LV(i-1, Settings.Period)) then
            dh = lh;
            l = L(i);
            flag = false;
        end
        pl = false;
    end
    
    if(flag) then
        if(H(i) >= h) then
            h = H(i);
        else
            h = lh;
            pl = true;
        end
    else
        if(L(i) <= l) then
            l = L(i);
        else
            l = ll;
            ph = true;
        end
    end
    
    return dh, dl; 
end