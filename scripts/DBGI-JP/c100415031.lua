--竜輝巧-ファフニール

--Scripted by mallu11
function c100415031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100415031+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100415031.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c100415031.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c100415031.effectfilter)
	c:RegisterEffect(e3)
	--level down
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100415031,1))
	e4:SetCategory(CATEGORY_LVCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c100415031.lvcon)
	e4:SetTarget(c100415031.lvtg)
	e4:SetOperation(c100415031.lvop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c100415031.thfilter(c)
	return c:IsSetCard(0x250) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(100415031) and c:IsAbleToHand()
end
function c100415031.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100415031.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100415031,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100415031.effectfilter(e,ct)
	local etype=Duel.GetChainInfo(ct,CHAININFO_EXTTYPE)
	return etype&(TYPE_RITUAL+TYPE_SPELL)==TYPE_RITUAL+TYPE_SPELL
end
function c100415031.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x250)
end
function c100415031.lvfilter(c,e)
	return c:IsFaceup() and c:IsLevelAbove(2) and c:IsAttackAbove(1000) and (not e or c:IsRelateToEffect(e))
end
function c100415031.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100415031.confilter,tp,LOCATION_MZONE,0,nil)
	return eg:IsExists(c100415031.lvfilter,1,nil,nil) and #g-eg:Filter(c100415031.confilter,nil):FilterCount(Card.IsControler,nil,tp)>0
end
function c100415031.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c100415031.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c100415031.lvfilter,nil,e)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		local lv=math.floor(atk/1000)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
