--Snow Shard Lands
local s,id=GetID()
function c62070240.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(function(e,c) return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)*-100 end)
	c:RegisterEffect(e3)
end

s.listed_series={0x85a,0x95}

function s.thfilter(c)
	return c:IsSetCard(0x85a) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if #g>0 and Duel.SelectEffectYesNo(tp,e:GetHandler(),95) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function s.filter(c,dct) 
	return ((((c:IsSetCard(0x177) and not c:IsCode(id)) or c:IsSetCard(0x1178)) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x95) and c:GetType(TYPE_SPELL)))
		and (c:IsAbleToHand() or dct>1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,dct) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,dct):GetFirst()
	if tc then
		aux.ToHandOrElse(tc,tp,function(c) return dct>1 end,
		function(c)
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(c,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1) end,
		aux.Stringid(id,3))
	end
end