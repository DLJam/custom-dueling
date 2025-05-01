--Three Musketeers - Lively Missile
local s,id=GetID()
function c2143601.initial_effect(c)
	--Destroy adjacent to monster cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function s.cfilter(c,tc,seq)
	if tc:IsLocation(LOCATION_SZONE) and c:IsControler(tc:GetControler()) then
		if c:IsLocation(LOCATION_MZONE) then return c:IsSequence(seq) end
		return true
	elseif tc:IsLocation(LOCATION_MZONE) then
		if c:IsLocation(LOCATION_SZONE) then
			return tc:IsInMainMZone() and tc:GetColumnGroup():IsContains(c) and c:IsControler(tc:GetControler())
		elseif c:IsLocation(LOCATION_MZONE) then
			if c:IsInExtraMZone() or tc:IsInExtraMZone() then
				return tc:GetColumnGroup():IsContains(c)
			else
				return c:IsSequence(seq-1,seq+1) and c:IsControler(tc:GetControler())
			end
		end
	end
	return false
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	local g=tc:GetColumnGroup(1,1):Filter(s.cfilter,nil,tc,tc:GetSequence())
	g:Merge(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=tc:GetColumnGroup(1,1):Filter(s.cfilter,nil,tc,tc:GetSequence())
		g:Merge(tc)
		Duel.Destroy(g,REASON_EFFECT)
	end
end