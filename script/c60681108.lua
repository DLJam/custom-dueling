--Emperor Dragon Power - Abyssal Majesty
local s,id=GetID()
function c60681108.initial_effect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==1-tp and re:IsMonsterEffect() and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace(RACE_DRAGON) and Card.IsAttribute(ATTRIBUTE_DARK) and IsLevelAbove(8) or IsRankAbove(8)),tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(s.chngtg)
	e1:SetOperation(s.chngop)
	c:RegisterEffect(e1)
	
end
function s.chngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAbleToHand),rp,0,LOCATION_MZONE,1,nil) end
end
function s.chngop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsAbleToHand),tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,nil,REASON_EFFECT)
	end
end