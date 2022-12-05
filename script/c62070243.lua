--Snow Shard Beast Master, Inu
local s,id=GetID()
function c62070243.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),5,2)
	c:EnableReviveLimit() 
end
