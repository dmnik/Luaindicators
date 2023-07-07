Settings = {
	Name = "Minute-HL",
	Minutes = 60,
	line = {
	{
		Name = "HI",
		Color = RGB(0, 0, 255),
		Type = TYPE_LINE,
		Width = 1
	},
	{
		Name = "LOW",
		Color = RGB(255, 0, 0),
		Type = TYPE_LINE,
		Width = 1
	}
  }
}

function Init()	
	
	M_High = -1
	M_Low = -1
	
	Hour = -1

	return 2
end

function OnCalculate(index)
	local High, Low, Open, Close
	local hour
	
	High = H(index)
	Low = L(index)
	
	if(Hour ~= math.floor((T(index).hour*60 + T(index).min)/Settings.Minutes)) then
	
		D_High = M_High
		D_Low = M_Low
		
		M_High = -1
		M_Low = -1
		
		Hour = math.floor((T(index).hour*60 + T(index).min)/Settings.Minutes)
	end
	
	if (High > M_High) or (M_High == -1) then
		M_High = High
	end
	
	if (Low < M_Low) or (M_Low == -1) then
		M_Low = Low
	end
  
	return D_High, D_Low
end
