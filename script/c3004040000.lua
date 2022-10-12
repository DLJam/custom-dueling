--I'm Feeling the Flow!
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		s[2]=0
		s[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop()
	for tp=0,1 do
		if not s[tp] then s[tp]=Duel.GetLP(tp) end
		if s[tp]>Duel.GetLP(tp) then
			s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
			s[tp]=Duel.GetLP(tp)
		end
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
		and Duel.GetDrawCount(tp)>0
		and s[2+tp]>=0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	--draw replace
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ac0=duel.createtoken(tp,64591429)
	Duel.SendToHand(ac0,nil,REASON_EFFECT)
	local ac1=duel.createtoken(tp,69852487)
	Duel.SendToHand(ac1,nil,REASON_EFFECT)
	local ac2=duel.createtoken(tp,84013237)
	Duel.SendToDeck(ac2,nil,REASON_EFFECT)
	local ac3=duel.createtoken(tp,7194917)
	Duel.SendtoDeck(ac3,nil,REASON_EFFECT)
	local ac4=duel.createtoken(tp,66011101)
	Duel.SendtoDeck(ac4,nil,REASON_EFFECT)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
			s[2+tp]=0
	end
		Duel.ConfirmCards(1-tp,g)
end
