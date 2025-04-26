--Emperor Dragon Power - Abyssal Majesty
local s,id=GetID()
function c60681108.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==1-tp 
					and re:IsMonsterEffect() 
					and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace, RACE_DRAGON) and aux.FaceupFilter(Card.IsAttribute, ATTRIBUTE_DARK) and (aux.FaceupFilter(Card.IsLevelAbove, 8) or aux.FaceupFilter(Card.IsRankAbove,8)),tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(s.chngtg)
	e1:SetOperation(s.chngop)
	c:RegisterEffect(e1)
	
end
function s.chngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(1,rp,0,LOCATION_MZONE,1,nil) end
end
function s.chngop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(1-tp,1,tp,0,LOCATION_MZONE,1,1,nil)
	g.AddCard(g,g2)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end