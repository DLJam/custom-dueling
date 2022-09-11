--Dragon Lord Magican, Summoner
local s,id=GetID()
function c6853283.initial_effect(c)
    --lv change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
    --unsynchroable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
   	--Xyz material limitations
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_XYZ_MAT_RESTRICTION)
	e4:SetValue(s.filter)
	c:RegisterEffect(e4)
end
s.listed_series={0x41A}
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local lv=e:GetHandler():GetLevel()
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
    e:SetLabel(Duel.AnnounceLevel(tp,1,12,lv))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function s.lvfilter1(c,tp)
	return c:IsFaceup() and c:HasLevel() and c:IsSetCard(0x41A)
		and Duel.IsExistingMatchingCard(s.lvfilter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function s.lvfilter2(c,lv)
	return c:IsFaceup() and c:HasLevel() and not c:IsLevel(lv)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.lvfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.lvfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local g=Duel.GetMatchingGroup(s.lvfilter2,tp,LOCATION_MZONE,0,tc,lv)
		local lc=g:GetFirst()
		for lc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
		end
	end
end
function s.filter(e,c)
	return c:IsSetCard(0x41A)
end
