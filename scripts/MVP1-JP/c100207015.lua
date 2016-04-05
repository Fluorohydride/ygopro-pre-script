--アップル・マジシャン・ガール
--Apple Magician Girl
--Script by mercury233
function c100207015.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetTarget(c100207015.sptg)
	e1:SetOperation(c100207015.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c100207015.thcon)
	e2:SetTarget(c100207015.thtg)
	e2:SetOperation(c100207015.thop)
	c:RegisterEffect(e2)
end
function c100207015.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100207015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100207015.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100207015.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100207015.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local a=Duel.GetAttacker()
		if a and a:IsAttackable() and a:IsFaceup() and not a:IsImmuneToEffect(e) and not a:IsStatus(STATUS_ATTACK_CANCELED) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(g:GetFirst())
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(math.ceil(a:GetAttack()/2))
			a:RegisterEffect(e1)
		end
	end
end
function c100207015.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c100207015.thfilter(c)
	return c:IsSetCard(0x20a2) and c:IsAbleToHand()
end
function c100207015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c100207015.thfilter,tp,LOCATION_GRAVE,0,1,c) end
	local g=Duel.GetMatchingGroup(c100207015.thfilter,tp,LOCATION_GRAVE,0,c):Filter(Card.IsCanBeEffectTarget,nil,e)
	local tg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		tg:Merge(sg)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	until tg:GetCount()==3 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(100207015,0))
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
end
function c100207015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
