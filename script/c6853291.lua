--Storming Dragon Lord, Gale Highwind
local s,id=GetID()
function c6853291.initial_effect(c)
	--Synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x41A),1,1,Synchro.NonTunerEx(s.matfilter),1,1)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Bounce on Synchro & Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Apply effects
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end

s.listed_series={0x41A}

function s.matfilter(c,val,scard,sumtype,tp)
	return c:IsRace(RACE_DRAGON,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_WIND,scard,sumtype,tp) and c:IsSetCard(0x41A,scard,sumtype,tp)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) or e:GetHandler():IsSummonLocation(LOCATION_GRAVE)
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
	--Return up to 2 cards
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

--Apply an effect Tribute a Dragon: cost filter
function s.atkfilter (c)
	return c:GetTextAttack()>0 and c:IsRace(RACE_DRAGON)
end
--Cost operation
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.atkfilter,1,false,nil,c) end
	local g=Duel.SelectReleaseGroupCost(tp,s.atkfilter,1,1,false,nil,c)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.Release(g,REASON_COST)
end

function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--defines a valid target
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	--Checks if option is possible to activate
	local b1=Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 end
	--Chooses what text to display
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,2)},
		{true,aux.Stringid(id,3)})
		e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_SZONE)
	elseif op==2 then
		e:SetCategory(0)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
  local op=e:GetLabel()
  if op==1 then
	--Destroy Spell Trap on field
	local dg = Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg = dg:Select(tp,1,1,nil)
	Duel.Destroy(sg,REASON_EFFECT)
  end
  if op == 2 then
	--Gain ATK
	local g1=e:GetLabelObject()
	local atk=g1:GetTextAttack()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_UPDATE_ATTACK) 
	  e1:SetValue(atk/2)
	  c:RegisterEffect(e1)
	  end
	end
end 