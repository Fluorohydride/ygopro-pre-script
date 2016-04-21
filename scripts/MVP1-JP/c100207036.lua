--方界帝ゲイラ・ガイル
--Geira Gale, the Cubic Emperor
--Scripted by Eerie Code
function c100207036.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c100207036.spcon)
	e2:SetOperation(c100207036.spop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c100207036.damcon)
	e3:SetTarget(c100207036.damtg)
	e3:SetOperation(c100207036.damop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c100207036.sptg2)
	e4:SetOperation(c100207036.spop2)
	c:RegisterEffect(e4)
end

function c100207036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and c:IsAbleToGraveAsCost()
end
function c100207036.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c100207036.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c100207036.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c100207036.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end

function c100207036.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c100207036.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c100207036.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c100207036.spfil(c,e,tp)
  return c:IsCode(100207032) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100207036.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100207036.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c100207036.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc>2 then lc=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then lc=1 end
	local g=Duel.SelectTarget(tp,c100207036.spfil,tp,LOCATION_GRAVE,0,1,lc,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c100207036.thfil(c)
	return c:IsCode(100207037) and c:IsAbleToHand()
end
function c100207036.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	if not (c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0) then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and tg:GetCount()>1 then
			local tc=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	if Duel.IsExistingMatchingCard(c100207036.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(100207036,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100207036.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
