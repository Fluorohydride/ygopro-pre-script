--ブエリヤベース・ド・ヌーベルズ
--Script by 小壶
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(aux.TRUE)
	c:RegisterEffect(e3)
end
--spsummon success
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		return Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if not g or #g<5 then return end
	g=g:Filter(Card.IsAbleToHand,nil):Filter(Card.IsSetCard,nil,0x293)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		g=g:Select(p,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g)
		Duel.ShuffleHand(p)
	end
	Duel.ShuffleDeck(p)
end
--be target
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function s.tgf2_1(c)
	return c:IsReleasableByEffect() and c:IsPosition(POS_ATTACK)
end
function s.tgf2_2(c,e,tp)
	return c:IsSetCard(0x293) and c:IsLevel(2,3) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:GetType()&0x81==0x81
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasableByEffect() and Duel.IsExistingMatchingCard(s.tgf2_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.tgf2_2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.tgf2_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	if g:GetCount()==0 then return end
	g:AddCard(e:GetHandler())
	if Duel.Release(g,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.tgf2_2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:RegisterFlagEffect(100420029,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100420029,2))
	end
end
