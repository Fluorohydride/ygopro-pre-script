--Mayakashi Mayhem
--Scripted by: XGlitchy30
function c100265056.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choose effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,100265056)
	e2:SetCondition(c100265056.effcon)
	e2:SetTarget(c100265056.efftg)
	e2:SetOperation(c100265056.effop)
	c:RegisterEffect(e2)
end
--CHOOSE EFFECT
--filters
function c100265056.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_ZOMBIE) and c:GetSummonLocation()~=LOCATION_EXTRA
end
function c100265056.setfilter(c)
	return c:IsSetCard(0x121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(100265056)
end
function c100265056.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
---------
function c100265056.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100265056.cfilter,1,nil)
end
function c100265056.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1) and (Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x1)==0)
	local b2=Duel.IsExistingMatchingCard(c100265056.setfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x2)==0)
	local b3=Duel.IsExistingMatchingCard(c100265056.tgfilter,tp,0,LOCATION_MZONE,1,nil) and (Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x4)==0)
	local b4=(Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x8)==0)
	if chk==0 then return b1 or b2 or b3 or b4 end
end
function c100265056.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local off=1
	local ops={}
	local opval={}
	----
	local b1=Duel.IsPlayerCanDraw(tp,1) and (Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x1)==0)
	local b2=Duel.IsExistingMatchingCard(c100265056.setfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x2)==0)
	local b3=Duel.IsExistingMatchingCard(c100265056.tgfilter,tp,0,LOCATION_MZONE,1,nil) and (Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x4)==0)
	local b4=(Duel.GetFlagEffect(tp,100265056)<=0 or bit.band(Duel.GetFlagEffectLabel(tp,100265056),0x8)==0)
	----
	if b1 then
		ops[off]=aux.Stringid(100265056,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100265056,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(100265056,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(100265056,3)
		opval[off-1]=4
		off=off+1
	end
	local sel=Duel.SelectOption(tp,table.unpack(ops))+1
	if sel==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,100265056)<=0 then
			Duel.RegisterFlagEffect(tp,100265056,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetFlagEffectLabel(tp,100265056,Duel.GetFlagEffectLabel(tp,100265056)|0x1)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c100265056.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end	
		if Duel.GetFlagEffect(tp,100265056)<=0 then
			Duel.RegisterFlagEffect(tp,100265056,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetFlagEffectLabel(tp,100265056,Duel.GetFlagEffectLabel(tp,100265056)|0x2)
	elseif sel==3 then
		local g=Duel.GetMatchingGroup(c100265056.tgfilter,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			local tg=g:GetMinGroup(Card.GetAttack)
			if #tg>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=tg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			else
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
		if Duel.GetFlagEffect(tp,100265056)<=0 then
			Duel.RegisterFlagEffect(tp,100265056,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetFlagEffectLabel(tp,100265056,Duel.GetFlagEffectLabel(tp,100265056)|0x4)
	else
		Duel.Damage(1-tp,800,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,100265056)<=0 then
			Duel.RegisterFlagEffect(tp,100265056,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetFlagEffectLabel(tp,100265056,Duel.GetFlagEffectLabel(tp,100265056)|0x8)
	end
end